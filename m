Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF285B4738
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiIJPHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 11:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIJPHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 11:07:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2100D4D261
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 08:07:51 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so3789506wms.5
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 08:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date;
        bh=sHwh5eWHsYNTzfMpFZg0EMKGneecJDiFNUKxuNH24ZY=;
        b=XNqoChKFmIXagm/VTHSaCtnk8gDXCd4lhqBaHPfYuLHwDj2SWCiTOD+Gah/qlBEGMX
         L54VMZQLw1FACIpwFc3s8chRwvko0i372ltVKqU6r5KO2nYoK8Ev4/IT14uPudb5nXz1
         UnLtJhSuosvV5Dzo+EyiNubsKDS5bSHXgMvYK6EtOZfzEEuZfHfoSKjtLE0IJCpQ3PGB
         G+Wii59pspMLGeI7qq+eheefaZhckdB6jn+MJcJaLmKs9rDxHJYjozE1vx76hZ4ImkUU
         s4RmOKxzYg/N3jdNybvAJiOULXsB7gboinNZLZM7IckCyWajwvFS4aRQCYDoIwDmJOVu
         N9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sHwh5eWHsYNTzfMpFZg0EMKGneecJDiFNUKxuNH24ZY=;
        b=qTtLC4cGGx2UY3dp7ps4M14nAqlM9fTjoaG0+3+fOLHbJfKFpuBMAJJNVKkUXjF1/n
         d8FDO2ezdbQ3Vsf0hVNZOxsbK6qIQKPp4xOZyJTeCDyq4yNMNVSli7Dmkrc8AALBbwt4
         MoyrM4IbdG8oQjCOnh491iCcfY/FrgEHVvgPMBTT58L6jcaRF1VG9dMd8qg/LhQdqdr5
         7TO0uPxBaYNN+oAUddaZ2/E9BM6lmdwXpFkVaHkGJzn9Q8PGxy1C+2ToHEON8cLKkF2V
         NLY0YEsGLuwuRQy/9jQ1GhTodlgqKtxtP6YBQc8zwEQf3H7Q5APYsmwsvv8farB3X61q
         8zRg==
X-Gm-Message-State: ACgBeo2I5a5yzhvkpXEjHxIMLzILjmkkhFdqHqKdUXx9LAr0mh7ruqpZ
        ial1t8EWc0u5UhCiMnYT8m4QUy5y/yApeg==
X-Google-Smtp-Source: AA6agR6IcQibPk/pX0DRfsFXbGSYpyYZn5OdEOVsRXso2Ur8YlZl/snWyxNjcNGQvFyPZ2NcqHd1eQ==
X-Received: by 2002:a05:600c:601b:b0:3a8:4fd1:ec70 with SMTP id az27-20020a05600c601b00b003a84fd1ec70mr8531690wmb.126.1662822469388;
        Sat, 10 Sep 2022 08:07:49 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b61:b014:9026:5075:17dd:ebfe:8e6a])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b003a4f08495b7sm4049297wmq.34.2022.09.10.08.07.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Sep 2022 08:07:48 -0700 (PDT)
From:   Lasse Johnsen <lasse@timebeat.app>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-Id: <448285BC-C58E-475C-BAA2-001501503D6C@timebeat.app>
Date:   Sat, 10 Sep 2022 16:07:48 +0100
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
To:     Richard Cochran <richardcochran@gmail.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFHi Richard,

I understand your point and your concern.

Would you be amenable to an addition to the API so we can take advantage =
of=20
hardware that offers only a subset of the options?

We could for example extend granularity of the HWTSTAMP TX API to make =
requests=20
for different features visible to the user space applications directly. =
So the TX side=20
would become much more granular as is already the case with the RX side. =
We could=20
add HWTSTAMP_TX_ONESTEP_SYNC_L2_V2, HWTSTAMP_TX_ONESTEP_SYNC_L4_V2 etc.=20=


My worry is that if we do not do this, then the ONESTEP option will =
continue=20
to not see much use because so many permutations (L2, UDPv4, UDPv6, V1, =
V2, VLAN etc.)
currently have to be supported by the hardware.

I like Intel=E2=80=99s cards. I want to support the features provided by =
the hardware=E2=80=A6 :-)

If you agree with this approach, then I will submit instead two patches: =
One patch that=20
extends the API and another modified version of the current igc patch =
which will=20
use the new more granular option. For the former, I will try and =
persuade (...beg... I will beg...)=20
JL to supervise the API work so it does not go off the rails :-)

In parallel, I have reached out to Kevin and asked if the 1-step logic =
will ever be able to
update the UDP checksum on-the-fly in which case I shall certainly =
include this functionality
as well.

Let me know what you think.

All the best,

Lasse

> On 9 Sep 2022, at 15:21, Richard Cochran <richardcochran@gmail.com> =
wrote:
>=20
> On Fri, Sep 09, 2022 at 09:51:23AM +0100, Lasse Johnsen wrote:
>=20
>> So where the driver received an ioctl with tx config option =
HWTSTAMP_TX_ONESTEP_SYNC it will process=20
>> skbs not matching the above criteria (including  PTP_CLASS_IPV4) as =
it would have had the tx config option=20
>> been HWTSTAMP_TX_ON. This patch does not change the behaviour of the =
latter in any way.
>>=20
>> Therefore a user space application which has used the =
HWTSTAMP_TX_ONESTEP_SYNC tx config option
>> and is sending UDP messages will as usual receive those messages back =
in the error queue with=20
>> hardware timestamps in the normal fashion. (provided of course in the =
case of this specific driver that
>> another tx timestamping operation is not in progress.)
>=20
> Okay, then I must NAK this patch.  If driver offers one-step and user
> enables it, then it should work.
>=20
> The option, HWTSTAMP_TX_ONESTEP_SYNC, means to apply one-step to any
> and all Sync frames, not just layer 2.  The API does not offer a way
> to advertise or configure one-step selectively based on network layer.
>=20
> Thanks,
> Richard

