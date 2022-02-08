Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350654AD453
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349656AbiBHJHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349138AbiBHJHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:07:24 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D1AC0401F0;
        Tue,  8 Feb 2022 01:07:23 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id v129so8100002wme.2;
        Tue, 08 Feb 2022 01:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=vpEZx2aDaRD4hwz/cgEGHsBbudveBVKpDQc3oNrzJIc=;
        b=A1mUx61Urxs2tc3tDNhFy5T2KYzXThskLrNm4DZWlKBPDM1U1/UpjS3L5MCLg7Nwp0
         lruhQU7oJCghLyzpYkjK7jdMiWwSWztmQCbknVuOk1DFg94SmfPNWpwfsExjOy/+8Vt2
         MaMwlHLqPHn1YWbEMte4iUQ8Yfewa66RLkgp82QG3HJN5HRJDSV3Effiw9CKp9UWNc1z
         ux7bPK+bV8P8z1E/scBFoGuZT3y/GCGzIP9ULqrTl/JNZ69tR/PyHRlu4yQ3e+Rm7qSp
         Wyb552MCBAUv/yNsVjtNq7jOSEXvcY+mKjUYPm3iP7AYBZbFP8puo7690NMGVYyUi97N
         p8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vpEZx2aDaRD4hwz/cgEGHsBbudveBVKpDQc3oNrzJIc=;
        b=Py6gUAQsB4NQwm5Vs2POQHtHWDtf6FebIob+SdHBSziZFCdmFWH+s8hsPbzqiegOH4
         YJNNo3fsNPYyYegwCNQEoYc949FGNIF/zBHsJxyOCuqdrVu6pVekXjmWGn11t1B/l4+F
         wO7eOkmghkdpTSZVvdyfVpoqLo8aQmSBIAtfIFhBobP2YCh6WrEPW0TS/Wi27c5WT+Nm
         uGQTzh/+p6+B+9qKCJH+DTNH34/uZy3RSHVjyB9oziLbFsI6ga2PIVp1LkAnBDP7A77t
         efbkR4KvIe9l/2Mly83CV2vHRNI5M959ckdvFlzxa1uOABew4m/pAyZntwjQfO0qeyFn
         9RRQ==
X-Gm-Message-State: AOAM530yARSNHgyxuHmvn6l8OfL1dvp9JNZhTApYTS7kBkeKkJjfel1C
        xeqJqofAQkUSS92LlvDAwT8=
X-Google-Smtp-Source: ABdhPJwGj5CMnZHIBULLOZXgzOyt/GzqPmlJb8H7Fsp+QBjdmImqlhcfcnu04//CymPcII4Qucj2gA==
X-Received: by 2002:a05:600c:4f06:: with SMTP id l6mr228404wmq.126.1644311241631;
        Tue, 08 Feb 2022 01:07:21 -0800 (PST)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id u7sm585007wrm.15.2022.02.08.01.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 01:07:21 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/4] net: bridge: Add support for bridge port
 in locked mode
In-Reply-To: <YgEkXARS160I9Ooe@lunn.ch>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-2-schultz.hans+netdev@gmail.com>
 <YgD5MglBy/UbN0uX@shredder> <YgEkXARS160I9Ooe@lunn.ch>
Date:   Tue, 08 Feb 2022 10:06:43 +0100
Message-ID: <867da5viak.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m=C3=A5n, feb 07, 2022 at 14:53, Andrew Lunn <andrew@lunn.ch> wrote:
>> > +	if (p->flags & BR_PORT_LOCKED) {
>> > +		fdb_entry =3D br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>> > +		if (!(fdb_entry && fdb_entry->dst =3D=3D p))
>> > +			goto drop;
>>=20
>> I'm not familiar with 802.1X so I have some questions:
>
> Me neither.
>
>>=20
>> 1. Do we need to differentiate between no FDB entry and an FDB entry
>> pointing to a different port than we expect?
>
> And extending that question, a static vs a dynamic entry?
>
>     Andrew

The question is - if there is an fdb entry or not - for the specific client
mac address behind the locked port in the bridge associated with the
respective locked port and vlan taken into consideration.
Normally you would have learning disabled, or from a fresh start if a port
is locked, it will not learn on incoming from that port, so you need to
add the fdb entry from user-space. In the common case you will want to
use static entries and remember the master flag for the entry to go to
the bridge module.
