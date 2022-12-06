Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859C66442E2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiLFMFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiLFMFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:05:30 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF1462F8
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:03:52 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5EFCA4154B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670328230;
        bh=brtPlso4v+WsnAGgbWLqD0qaP/DWC2mCOIzkN3hJ/jA=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
         Content-Type:MIME-Version;
        b=vQgYUQJuLPKXqNAZMWApdUR/2on1hLrF/Qr5rzgFcA+P4HkOLvCGJrW7dMZLHdNog
         OHLW13wP/HLfR/+xLYQFrsxjvW0ApjX09e4P2/ezJlunYn6MvOP9ndZYiQBQmJ4vNU
         0PDT843Xgce/ksnR4xYqpQOtc7IC/F8bqbPt1zYdkP8aIMM7Ff4wBhB3yTRYTdkttk
         TJbhNWnW7eunmeeK5yhvoAe0X/AYAUWphmDKsVTi44+uR5gB+N/BaTLZO3mVgtOlMS
         fq1AtC5yreQFDFehMfc/rbhGKyfKa3rKVg9Nh6Q/n6aVukgRGlpX3QYN204gbjlHWe
         NhzWJzAkBUFUQ==
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402350d00b00464175c3f1eso7770804edd.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:03:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=brtPlso4v+WsnAGgbWLqD0qaP/DWC2mCOIzkN3hJ/jA=;
        b=7NPtOGtPiO5wGgY5vNrbWMg6+hwze8I3caWV4JtCsgxQQGQAOzsJFGL2oztA3lDc1w
         J2LR+T9cNVX+095zrOHgx//jmAzjFZ+eEpAorCga7EHuJPkz61pFootREnzruVuBq3B0
         IK9gEKeg+dScwN4R3IklEMuDp48MhZSodQj0lNtg4lrABQLaoxbfaP9qso8iS5vcqIw7
         mlDotA6KleZYDJfE1t43E7h3YbRCsy5sNJAcogDq6IIdDumNF0Wo+cJA5/Qo1nR2Tioy
         Yj6ZRftDasU5Ee4Hwn5VO0m0fY+NBisYvut5flv9TZCIQ4djL5zpwi4XKsZZVmAyJXvx
         skpQ==
X-Gm-Message-State: ANoB5pm6pHb/NKPCcrAX+go+y7jix7lHf1AHDvElESO+/gacMZiiH3v0
        u+lbRfWwgCsEDznSNwcvR74ABHGVm17/QGMnwhU6khsDiVxS5+KFXGAcxP8gBLmNhgv49QEkGY7
        Oc4CYZSb1e5GafSDW9Lf36WjFWC++UwGz/Q==
X-Received: by 2002:a17:906:1310:b0:7c0:c5e9:634d with SMTP id w16-20020a170906131000b007c0c5e9634dmr15321583ejb.220.1670328227916;
        Tue, 06 Dec 2022 04:03:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf53XzYQZ9m1URY2w6jlEHp7rS5tCFGriu9rXA6LSOHfWrCMGtPfHrgs+qnXI07YhR2WvnFdNg==
X-Received: by 2002:a17:906:1310:b0:7c0:c5e9:634d with SMTP id w16-20020a170906131000b007c0c5e9634dmr15321567ejb.220.1670328227650;
        Tue, 06 Dec 2022 04:03:47 -0800 (PST)
Received: from [192.168.1.27] ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id gg9-20020a170906e28900b007c0d41736c0sm4138501ejb.39.2022.12.06.04.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:03:47 -0800 (PST)
Message-ID: <a22e2c8de905d7f9d3cf3525269487a6b5da4bf5.camel@canonical.com>
Subject: Re: Regarding 711f8c3fb3db "Bluetooth: L2CAP: Fix accepting
 connection request for invalid SPSM"
From:   Cengiz Can <cengiz.can@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:03:34 +0300
In-Reply-To: <Y48sR0xv0yuH8GDd@kroah.com>
References: <f0b260c1-a7c4-9e0e-5b29-a3c8a7570df1@canonical.com>
         <Y48sR0xv0yuH8GDd@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-06 at 12:49 +0100, Greg KH wrote:
>=20
> I've already done this backport and it is in the latest -rc1 stable
> kernel releases.  Is it not working for you there?  Why do it again?

Sorry for the noise. I was just trying to make sure that I'm following
the right path.

I know that 4.4.y is no longer actively maintained but I was trying to
backport it to there as well.

Sorry for the noise again.

Cengiz Can

