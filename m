Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0C4B965F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiBQDKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:10:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiBQDKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:10:44 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D46823D5D9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:10:30 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id c15so6220961ljf.11
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0euhP8nubaU6WBXyhjYDPi52gtd6i6I50apBmkPNuk=;
        b=I+DpLfictbDyFOxxHHFVngjwYy8otVGBtvIPNhJFklsZo2y/4N9mUmjnd4Ha8yVZA7
         K7HmLwlb5JRp9pe23p4tJFap8m154tVHt60GoRqPtlWryd9YcbUbLN3byAk3BI8pnUdb
         vj5qgPbDEMTVhU9eGxal3PUjohVMJw4c7DKA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0euhP8nubaU6WBXyhjYDPi52gtd6i6I50apBmkPNuk=;
        b=Xofpk4ydVZaFX1JftohHbqq2VmMgNCjl7A/oqncv2LJjzwwbYUE2aKLbYlOpW3LXVg
         nKybGcNopNTm4ddsvxCU1raOZoOi3GCBZS/dm6DMaRZXfyCh++Z6UqefdJCeSEZ1MgII
         zo8RsAtFXFkBGV6YeZpOo1EBkHRhe4axffn0uzRZiYaE6RMq2XzxvfttwXHd7OswGunk
         B2tTNmz+Lpf1rTREJajyONQd4vpkvVCuua5Z5Dv2ICp7I3bXKqexbdp3yaD2URzcTmsk
         VlljwVZFH2Iy8SD1ZQPmEBP899Ffoc22hdm0urVdgtqtVXE04GmDA6hxMIWQODNAxCOL
         PAow==
X-Gm-Message-State: AOAM533r8SgX7YpY1vP3E5V5C5wujOsEQk3z0VZ1qiiE+RF8KuQWRMkd
        9HMrbSHejxKAk6NCYrCcwS0+Gn+K6dm8osB+aoL/iQ==
X-Google-Smtp-Source: ABdhPJytVXZWGTBfCwjROZZpTSgyEDBdB5d2xLfgWvVctlIFC2T9VSIX+eu3aXjYpr/H6F7CkbmAKlXragO9X0JObu0=
X-Received: by 2002:a2e:90cb:0:b0:22e:5363:95f0 with SMTP id
 o11-20020a2e90cb000000b0022e536395f0mr763966ljg.210.1645067428501; Wed, 16
 Feb 2022 19:10:28 -0800 (PST)
MIME-Version: 1.0
References: <20220110015636.245666-1-dmichail@fungible.com>
 <20220110015636.245666-8-dmichail@fungible.com> <20220112143532.3aab21e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220112144013.1060a854@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112144013.1060a854@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 16 Feb 2022 19:10:15 -0800
Message-ID: <CAOkoqZ=Zx-N=jRgK-ZATgm5WY6K+Ky0-HedurmEo+JDkOqAL_g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 7/8] net/funeth: add kTLS TX control part
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 2:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Jan 2022 14:35:32 -0800 Jakub Kicinski wrote:
> > > +   if (crypto_info->version == TLS_1_2_VERSION)
> > > +           req.version = FUN_KTLS_TLSV2;
> > > +   else if (crypto_info->version == TLS_1_3_VERSION)
> > > +           req.version = FUN_KTLS_TLSV3;
>
> I don't think offload of TLS 1.3 is supported by the kernel.
>
> > > +   else
> > > +           return -EOPNOTSUPP;
> > > +
> > > +   switch (crypto_info->cipher_type) {
> > > +   case TLS_CIPHER_AES_GCM_128: {
> > > +           struct tls12_crypto_info_aes_gcm_128 *c = (void *)crypto_info;
> > > +
> > > +           req.cipher = FUN_KTLS_CIPHER_AES_GCM_128;
> > > +           memcpy(req.key, c->key, sizeof(c->key));
> > > +           memcpy(req.iv, c->iv, sizeof(c->iv));
> > > +           memcpy(req.salt, c->salt, sizeof(c->salt));
> > > +           memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > > +           break;
> > > +   }
>
> Neither are all the algos below. Please remove dead code.

I've removed the TLS 1.3 pieces and the non-offloaded 1.2 algos.

>
> > > +   case TLS_CIPHER_AES_GCM_256: {
> > > +           struct tls12_crypto_info_aes_gcm_256 *c = (void *)crypto_info;
> > > +
> > > +           req.cipher = FUN_KTLS_CIPHER_AES_GCM_256;
> > > +           memcpy(req.key, c->key, sizeof(c->key));
> > > +           memcpy(req.iv, c->iv, sizeof(c->iv));
> > > +           memcpy(req.salt, c->salt, sizeof(c->salt));
> > > +           memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > > +           break;
> > > +   }
> > > +
> > > +   case TLS_CIPHER_CHACHA20_POLY1305: {
> > > +           struct tls12_crypto_info_chacha20_poly1305 *c;
> > > +
> > > +           c = (void *)crypto_info;
> > > +           req.cipher = FUN_KTLS_CIPHER_CHACHA20_POLY1305;
> > > +           memcpy(req.key, c->key, sizeof(c->key));
> > > +           memcpy(req.iv, c->iv, sizeof(c->iv));
> > > +           memcpy(req.salt, c->salt, sizeof(c->salt));
> > > +           memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > > +           break;
> > > +   }
