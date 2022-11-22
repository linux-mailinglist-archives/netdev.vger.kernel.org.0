Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6A633465
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKVEXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKVEXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:23:32 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178591F625
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:23:31 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id j12so12487256plj.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7lLL7qM289jDC3C70clhpmuDor0yKHlczxRAFUa82I=;
        b=czCrEbFTdndmwuKkx5wkcTqzm6BGu7n8947RPn+hTkip89t/uwpMHeLCIhMPTvWVmQ
         Nxo3JIu3+OjYJ4/K6sqwvmkdL1xvaxbX9huv16OwfxK91uIkC2Y//hMEPT9ND0EU99oZ
         W9G1RhZlkDfOTZPfnL4q2rjVlyZX0jR9mx9S4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7lLL7qM289jDC3C70clhpmuDor0yKHlczxRAFUa82I=;
        b=U4AYzkRKykYp77qO5ENa6G8dgZgwHhXfMqf7V6ULP9y7otUf2MUIDk/t7QoLAMw3hL
         rKOdbCLSw2CZmxi2cCGZr9R3IyPayj/c4efH/QYZAIRaiDOOcpYUnQfYdpXi4qGZQEQa
         X+kUj65LphWLdkcn2WOAj/jN+nOHTufJvr3y9ZjRD7zoJSR8IkoKnOFS7j7J8bGz9DGS
         kEACEguuwb89n/wCauSDA1BcniTBEklUjGyCR3OjrR82lmSjWzK302Wf8opGHJA4cukA
         AK2Upx8V46KywXuFXwWu/QN4GdHpO0Ukjc/b7AqxpgynIH+9Otf1i2SOMZSe7i57TaoD
         Gpuw==
X-Gm-Message-State: ANoB5pm9LsZsvGoJd40GJfT9DcX/3lHbTYIPMK9+rTdkilbKke3+GLGA
        nQ4oCdeMj5lcblR9te8w2QJrFJGTg/PVpE7o
X-Google-Smtp-Source: AA0mqf7DwyAp7Kcnn4i/IfdQvZ3qzZzFM4xAr40YfuTXwz3PweIxwJ3mWEexrYygFUuzc7p1QJNJeg==
X-Received: by 2002:a17:903:191:b0:186:5cda:1e01 with SMTP id z17-20020a170903019100b001865cda1e01mr2999450plg.111.1669091010549;
        Mon, 21 Nov 2022 20:23:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v14-20020aa799ce000000b00573e0f0a711sm1093153pfi.195.2022.11.21.20.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 20:23:29 -0800 (PST)
Date:   Mon, 21 Nov 2022 20:23:28 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sam Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>
Cc:     Networking <netdev@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Subject: Re: warn in ncsi netlink code
Message-ID: <202211211936.9537DD8D@keescook>
References: <CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com>
 <74BE39CB-E770-4526-9FCD-CC602178E26F@mendozajonas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74BE39CB-E770-4526-9FCD-CC602178E26F@mendozajonas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 11:27:14AM +1100, Sam Mendoza-Jonas wrote:
> On November 17, 2022 3:35:17 PM GMT+11:00, Joel Stanley <joel@jms.id.au> wrote:
> >next-20221114 running on an ast2600 system produced this:
> >
> >[   44.627332] ------------[ cut here ]------------
> >[   44.632657] WARNING: CPU: 0 PID: 508 at net/ncsi/ncsi-cmd.c:231 ncsi_cmd_handler_oem+0xbc/0xd0
> >[   44.642387] memcpy: detected field-spanning write (size 7) of single field "&cmd->mfr_id" at net/ncsi/ncsi-cmd.c:231 (size 4)
> [...]
> >
> >The relevant code:
> >
> >static int ncsi_cmd_handler_oem(struct sk_buff *skb,
> >                                struct ncsi_cmd_arg *nca)
> >{
> >        struct ncsi_cmd_oem_pkt *cmd;
> >        unsigned int len;
> >        int payload;
> >        /* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
> >         * requires payload to be padded with 0 to
> >         * 32-bit boundary before the checksum field.
> >         * Ensure the padding bytes are accounted for in
> >         * skb allocation
> >         */
> >
> >        payload = ALIGN(nca->payload, 4);
> >        len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> >        len += max(payload, padding_bytes);
> >
> >        cmd = skb_put_zero(skb, len);
> >        memcpy(&cmd->mfr_id, nca->data, nca->payload);
> >        ncsi_cmd_build_header(&cmd->cmd.common, nca);
> >
> >        return 0;
> >}
> >
> >I think it's copying the command payload to the command packet,
> >starting at the offset of mfr_id:
> >
> >struct ncsi_cmd_oem_pkt {
> >        struct ncsi_cmd_pkt_hdr cmd;         /* Command header    */
> >        __be32                  mfr_id;      /* Manufacture ID    */
> >        unsigned char           data[];      /* OEM Payload Data  */
> >};
> >
> >But I'm not too sure.
> >
> >Cheers,
> >
> >Joel
> 
> 
> While it looks a little gross I'm pretty sure this is the intended behavior for the OEM commands. We'll need to massage that into something nicer.

Hi!

Ah, yes, another case of deserializing into a flexible array structure.
It looks like payload length is kept in cmd.common.length, and has
been effectively bounds-checked.

Regardless, we've been handling this in a couple ways:
1) split the struct member write from the dynamically sized
   portion of the write.
2) use unsafe_memcpy() with a good comment.

I'd like to be using a third option, a common deserializer[1], but it
doesn't exist yet. (This case would use the proposed mem_to_flex().)

In this case, since "payload" may be less than sizeof(mfr_id), I suspect
an unsafe_memcpy() is best.

-Kees

[1] https://lore.kernel.org/all/20220504014440.3697851-3-keescook@chromium.org/

-- 
Kees Cook
