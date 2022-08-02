Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16175588071
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiHBQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiHBQoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:44:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63BB965D6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659458638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8pobBAm4i46mJY839PgrpcD3mazYkh5vnTY9bSvya4=;
        b=Z4VN1OY7zRN9lFj5duGOn6HZvC+kptzkhJs646uxFvqxrZiLG5eIEqSrewetGTmu4PzM3w
        NC/PsQ/fjTqkNTJBkTQT4lwLRIurfj8YNFWfGKaCtMT/Z5EnHw5aUDV8xc1n2OMqypmmz+
        seMqOPqy4N29rFRt+EIEhXqM9N1wtKw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-PtWceG58OcyrimFoB2AreA-1; Tue, 02 Aug 2022 12:43:55 -0400
X-MC-Unique: PtWceG58OcyrimFoB2AreA-1
Received: by mail-wr1-f70.google.com with SMTP id c20-20020adfa314000000b0021f1757ea8aso2384325wrb.2
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 09:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L8pobBAm4i46mJY839PgrpcD3mazYkh5vnTY9bSvya4=;
        b=yafC5GZ+URVJE4eRc09MZTETmrGtFYCOAFIq9DewGKqatJsE1hHwFBLZz5jXkrB1E7
         1t47iW9QC1p5mkFc1PdNplYgxCn+v8i0UxyfFcyeAxSAIf4IfFBw7wMiJLynWb68bvTR
         eKajbTaRPq1bwYrwEIT+410h+r4rERe88ffhVQP9PJqtCYqu4JpW4uKBFtE7K6jAhcpf
         PiHrPj1AR+bKftdauzt0DMovu300P+ys6ulFdJkRr5jSuTKw2TQoJPuYmMJk77wDz+Af
         33NOYz0jyBtv2E8vC6pFOcK+J2IA7XDiijqR8v6MEmPsfapcIkvnxyywyhtzuBjrny9k
         Zk2Q==
X-Gm-Message-State: ACgBeo1/i/CUoFHZw98eTB5KWkfv5SZ4x7dWKNlqo1z8yMzrzXIaXi0+
        xEkKJXBOlKpYUkFtr3oIhbsT4fA+POReJXV1/pfwlTaD0OSsDqqOvUTTGl1eSzXP6G13MjWtXw2
        lEmwyPH5G7dgUL/it
X-Received: by 2002:a05:600c:3556:b0:3a3:2a9c:f26 with SMTP id i22-20020a05600c355600b003a32a9c0f26mr224963wmq.58.1659458633903;
        Tue, 02 Aug 2022 09:43:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ZAgXxc2CxG+KctR6fJdn0CsvShCyo8SoYUO7Uats0gOEPvqZKh1yx0XVMPje9AYIrimug6g==
X-Received: by 2002:a05:600c:3556:b0:3a3:2a9c:f26 with SMTP id i22-20020a05600c355600b003a32a9c0f26mr224944wmq.58.1659458633666;
        Tue, 02 Aug 2022 09:43:53 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id g16-20020a5d5410000000b00220633d96f2sm8460995wrv.72.2022.08.02.09.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 09:43:53 -0700 (PDT)
Date:   Tue, 2 Aug 2022 18:43:50 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org,
        jesse@nicira.com, pshelar@nicira.com, tgraf@suug.ch
Subject: Re: [PATCH v3 net] geneve: fix TOS inheriting for ipv4
Message-ID: <20220802164350.GA11906@pc-4.home>
References: <20220802122025.1364123-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802122025.1364123-1-matthias.may@westermo.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 02:20:25PM +0200, Matthias May wrote:
> The current code retrieves the TOS field after the lookup
> on the ipv4 routing table. The routing process currently
> only allows routing based on the original 3 TOS bits, and
> not on the full 6 DSCP bits.
> As a result the retrieved TOS is cut to the 3 bits.
> However for inheriting purposes the full 6 bits should be used.
> 
> Extract the full 6 bits before the route lookup and use
> that instead of the cut off 3 TOS bits.
> 
> This patch is the functional equivalent for IPv4 to the patch
> "geneve: do not use RT_TOS for IPv6 flowlabel"

This last sentence assumes this patch and your IPv6 series are going to
be merged roughly at the same time and with the same title. There's
no such guarantee though. So I think we can just drop the reference to
the IPv6 patch. But wait a day or two before sending a new version:
others might have different opinion, maintainers might want to apply
the patch as is or adjust the message manually, someone may have other
points to comment on...

Anyway, the rest of the commit message and the code look good to me.
Thanks for fixing this!

Acked-by: Guillaume Nault <gnault@redhat.com>

