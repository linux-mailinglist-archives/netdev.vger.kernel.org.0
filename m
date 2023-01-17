Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB266E1D6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjAQPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjAQPPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:15:16 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41207ABC;
        Tue, 17 Jan 2023 07:15:14 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-15b9c93848dso23988064fac.1;
        Tue, 17 Jan 2023 07:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ylWKwIJLJTbQVAo/fbc37J5qO2EJKxw6CVNTOjxtKk=;
        b=YNIhcWjK8ToP8HY9NsSJbmnDHddNpXTr3TgateiuRdZIZO0YVDqrAnbCKKEY7uFacC
         sdlXCHmtQryjfd8+8/irtUHDm5WlxPYLnX9jW+M4VNf+lJitmaqKqlDp+EZ+iSbtxuGg
         GXc3YBgY6eoY2X+InZcXIcjfKc3g9bDTQkiFBSaXUyNmGjMJEk/IkWWx4BjjPzasfVn8
         FeA+FeG/LB3H5/FyZqnTSe4whsMS18iAoMAtmwAW17s0t9ZHL12agONpA7GBEtu8M5/Q
         L/nTX00VJOCf8oVqX6hllN5S8X8Xrv4WkM9rhcO68NK8ugjWpSwy35GU5Y2MSX9jcvba
         X0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ylWKwIJLJTbQVAo/fbc37J5qO2EJKxw6CVNTOjxtKk=;
        b=kfL2PamfKywpX9pGz2D0J7P01tUF9E6sz0c3ZRlKDO9Hmx9raC0QjJ+0objRLS62/M
         B0ijsI7KlPOfi7hxhu7Je8tqm4d6nsKxjpI9RvxDBalb5lNqnA1GSXiY1IdDZu8XgwO9
         NuSIkEX4mH1lIC0LgqZvuu6QKpv3TrWkM1kz2+8uqaEc7SKsPQw06RRbmRjPX4kMsPaD
         cEtRE7rO4Er+GvbesclnQJZQIMK8v8RwfuKKnoYh4tExrMIedQ1jQ0OcT2SiKsPk7dRO
         3KUYfFUPJNlRGMP3yB6MO965XpWs7Ao2b/FzIAZvt6gXHVjOcUk8Wss0rWTOEJ6dAeDF
         dbhQ==
X-Gm-Message-State: AFqh2krwddbOUiP0NCoZdlFTX9/1f0EggnhiUetsBwpUWiT+u466JyJy
        3O5jgODA71d+sZxzo+StbOA=
X-Google-Smtp-Source: AMrXdXuG0IstA5kVlORkCqPzZtmvVlY0713eUbhfIZCyholb8mSv5OpNyrKrK77ocd6wxXR019QNsg==
X-Received: by 2002:a05:6871:4693:b0:15f:4552:877d with SMTP id ni19-20020a056871469300b0015f4552877dmr1888303oab.48.1673968513862;
        Tue, 17 Jan 2023 07:15:13 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:7189:754f:dfa5:a770:f05f])
        by smtp.gmail.com with ESMTPSA id p22-20020a056870831600b0014813cc4a51sm16460672oae.29.2023.01.17.07.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:15:13 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DC0E64AD200; Tue, 17 Jan 2023 12:15:11 -0300 (-03)
Date:   Tue, 17 Jan 2023 12:15:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 3/7] netfilter: flowtable: allow
 unidirectional rules
Message-ID: <Y8a7f2AXVMx8WWPc@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-4-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113165548.2692720-4-vladbu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 05:55:44PM +0100, Vlad Buslov wrote:
> Modify flow table offload to support unidirectional connections by
> extending enum nf_flow_flags with new "NF_FLOW_HW_BIDIRECTIONAL" flag. Only
> offload reply direction when the flag is not set. This infrastructure
                                           ^^^ s///, I believe? :-)

...
> -	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
> -					   FLOW_OFFLOAD_DIR_REPLY);
> +	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> +		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
> +						   FLOW_OFFLOAD_DIR_REPLY);
>  	if (ok_count == 0)
