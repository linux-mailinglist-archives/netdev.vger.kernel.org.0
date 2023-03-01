Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1956A6C74
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCAMhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCAMhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:37:53 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAE83CE2E
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 04:37:47 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id ec43so53122947edb.8
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 04:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6tmHSocb5Cwbm0XHFMhuhtDeylq8h81Scfthlsh6u0k=;
        b=LsTHdRNEX2LMUpC2R9iwpVdbrEQCBs8b1ABab7joWKMR872Qf5vYVlJs5sOBDqx7ys
         iI/VFapvUZGnl0LXEkpvorcAbDKskY3GvZGTjOUCA9Ts5YORJKxzena7pcgcYrb9946a
         ypbZpEZQUNn31VNNmv8VVzuzL9/mT8SEi+Zgue7wz/JuYDelqs3DkqLg18/fv3wNz1Kv
         QdkiqeUp4evUDQl2NKpphAqTK4ZqjfFqYKNeYzTlYXChHJA7zMArzn4n+eJ/GYUEhgqg
         1R++Uq5YaHYmCtrdDGGylWDnyNop29DlxZr0Bm2PG9dWBrS71HAXLxa7IsfxtX4BXnvD
         vKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tmHSocb5Cwbm0XHFMhuhtDeylq8h81Scfthlsh6u0k=;
        b=Rcd9MPHwNbVb2agM5kElB6IsHlXLT/XGpHUl/M501jI4QLofGO6rZZWxB5R5pJb3AA
         Udl3ypcGwbKQcrXe/Km6SWrXlwcxkXyy33o3RO4tRPqaILUEddFX/7YP6iv52wdsgeJQ
         AD7Xns/A3aGT2vek8gMTXXUdfriOEAFjffDRDNBzy77OvcQqAoLtG54pXrk/oOkMUGbV
         QHLj3+rcYsxPApLXBLwtdGUe+TVxqIsu9eh+y98VGFWnjdLFcxQyxNT5JP1qufldzV7/
         evOEi2U1V6h5qqLB1oKUfxz3mGbQ23kjTSRtzJxfq1bf4OhwTF6qqQamKV/QSmP8lRw5
         9+dw==
X-Gm-Message-State: AO0yUKX26rmjBM/6M7jhvQIuNtLilY9TqAD5X4jN53ZSt2YsgI7pOkMG
        aA9TTH9ksVRLR6kn0oX1BEU=
X-Google-Smtp-Source: AK7set/Fd9imfRBY1UPpVGICMtH48VJu9sc/usOEfjWhyUUEM7tsYR60Nae8bwrkYVOe7MHEo/zcJg==
X-Received: by 2002:aa7:cd0f:0:b0:4bd:8714:cc57 with SMTP id b15-20020aa7cd0f000000b004bd8714cc57mr796799edw.36.1677674266428;
        Wed, 01 Mar 2023 04:37:46 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a23-20020a50c317000000b004bc59951d6fsm635057edb.57.2023.03.01.04.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 04:37:46 -0800 (PST)
Date:   Wed, 1 Mar 2023 14:37:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230301123743.qifnk34pqwuyhf7u@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
 <20230228225622.yc42xlkrphx4gbdy@skbuf>
 <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 07:38:10AM +0100, Frank Wunderlich wrote:
> It was a userspace way to use the second ethernet lane p5-mac1 without
> defining p5 as cpu-port (and so avoiding this cpu-port handling).
> I know it is completely different,but maybe using multiple cpu-ports
> require some vlan assignment inside the switch to not always flood
> both cpu-ports with same packets. So p5 could only accept tagged
> packets which has to been tagged by userport.
> 
> How can i check if same packets processed by linux  on gmacs (in case
> i drop the break for testing)? Looking if rx increases the same way
> for both macs looks not like a reliable test.

I'd say that using a protocol with sequence numbers would be a good way
to do that. Most obvious would be ping (ICMP), but if the code comment
is right and MT7531_CFC[MT7531_CPU_PMAP_MASK] only affects link-local
multicast packet trapping (the 01:80:c2:00:00:xx MAC DA range), then
this won't do anything, because ping is unicast.

The next most obvious thing would be L2 PTP (ptp4l -2), but since mt7530
doesn't support hw timestamping, you'd need to try software timestamping
instead ("ptp4l -i swpX -2 -P -S -m", plus the equivalent command on a
link partner).

When testing, make sure that both CPU ports are active and their DSA
masters are up! Otherwise, the switch may send duplicate link-local
packets to both CPU ports, but DSA would only process one of them,
leading us to believe that there isn't any duplication.

Putting a tcpdump -i eth0 -w eth0.pcap and a tcpdump -i eth1 -w eth1.pcap
in parallel would also be a good way to double-check.
