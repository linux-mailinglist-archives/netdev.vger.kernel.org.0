Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8F168982F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjBCMAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 07:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbjBCMAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 07:00:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A480D953D0
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 04:00:48 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id mc11so14634831ejb.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 04:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LisVn22JGNO+hclfsq1rCHH7O5v3DImYPIPfevHRWFg=;
        b=Q+4m8pTqO0C0FFkwbygKeb357QpeY46qZxH7qN2jRgD8u3eXjfdoi+I0uMUAVP+pRJ
         mnyPtNc590ICqr92BU5sf4DobfvCRU7IVzsF/n69gD18JSJKSutuzgjwaB0jLuxFoXcp
         hWmZ8i03mlH0DSv2c/NHXk+5pIh6VGYLtf+flXK5jxsemqSKascMopn0BpCE3GO5xnwT
         YtAHtwFQnNwKmO/1CJg3hl3GtRUPcT62vcZmQacPCulvTT/7TY82iWzY/K8PDbDiLPqa
         tl1NoS+WxEZTWGNFhTSDg0hentXAQezZgenlI/KTphDvlzL7St0s3JsRfzbsQiGmbjRe
         Z/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LisVn22JGNO+hclfsq1rCHH7O5v3DImYPIPfevHRWFg=;
        b=c4EDfP9X+8oGsNydKMuaG8Lz2RsRnGg4ZZCRcK1H/WgogqSRCd93nDoa4bUgQ1iFo0
         LMq7VPoORjkXPtEi1EOdu5kiwZOOPOSLw9fXpHHi+tARVxfUCjBPWhv5YQ2JW3ajJSoj
         VntXfRrFhKweJWOnjew3cNNqAk1xTOIrOhfrdh2pflSs6yBgY85fyGpVe1sLD75By0KD
         ENWgpND33jx2RI7oLFx9UUbLVq0VXzmAdqpsDHTRL/jamHOUwrZTYZgwVKUzV0lp1FB/
         7t1REqN9q4Hdb3RkrNj9JHYPExTZ2dOV22ExajMfHbnhH1jHNx0IRAbv+eeHKc6D6Ugc
         WO1w==
X-Gm-Message-State: AO0yUKWjV2Oh+Z3xwYOasogrzVGK6wiQ1c2ShQDdvyRckTxF/LZJRbPX
        qEQJe60pZcHjr0eiirUk8sScpw==
X-Google-Smtp-Source: AK7set+N2cKYQT4nB9gmhqeY32Ipc2BVb/W4ySV5FzQM6YiqmJCuexZ/9s7PNo7coVO/tW0PvT2yQw==
X-Received: by 2002:a17:906:2012:b0:87f:2d81:1d2a with SMTP id 18-20020a170906201200b0087f2d811d2amr10410671ejo.35.1675425647074;
        Fri, 03 Feb 2023 04:00:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id um12-20020a170906cf8c00b008785b914883sm1267361ejb.116.2023.02.03.04.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 04:00:46 -0800 (PST)
Date:   Fri, 3 Feb 2023 13:00:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/1] net:openvswitch:reduce cpu_used_mask
 memory
Message-ID: <Y9z3bd4cUZdYpNs2@nanopsycho>
References: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
 <OS3P286MB2295DC976A51C0087F6FE16BF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB2295DC976A51C0087F6FE16BF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 03, 2023 at 10:51:18AM CET, taoyuan_eddy@hotmail.com wrote:
>Use actual CPU number instead of hardcoded value to decide the size
>of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>
>'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>8192 by default, it costs memory and slows down ovs_flow_alloc
>
>To address this, redefine cpu_used_mask to pointer
>append cpumask_size() bytes after 'stat' to hold cpumask
>
>cpumask APIs like cpumask_next and cpumask_set_cpu never access
>bits beyond cpu count, cpumask_size() bytes of memory is enough
>
>Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Sigh, I hope this is the last V, at least until I send this email...
