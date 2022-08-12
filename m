Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8008959133C
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbiHLPpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiHLPpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:45:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C73642AFF;
        Fri, 12 Aug 2022 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660319127;
        bh=w0NYj5A+TUnMhvnQe3ByTeL621CrZYXF3bjfm9j7Dz8=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=RJ/L9FvDMUr+NJlQ4d+i2rxUzrn7iqt0wWxMLUlFQ9WTsbW77LFBDb7f1NVwmgLWB
         ntd5T4cER8J6YqWaCHCkYNOe+PfgNRAmiolzBEASzs8grJoZSDNAZ1qH5oMwYURaOI
         JYMvh0vpWdlUz+WSnO9xDDfTOHstDK8L6Fl8AOTA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.2.10] ([155.133.221.219]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MDQic-1oC2jZ0qow-00ATFI; Fri, 12
 Aug 2022 17:45:27 +0200
Message-ID: <97b0e7ff-c099-c921-a283-43098d683781@gmx.de>
Date:   Fri, 12 Aug 2022 17:45:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: sfp: reset fault retry counter on successful
 reinitialisation
Content-Language: en-CA
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220812130438.140434-1-dac922@gmx.de>
 <YvZswfC/JhkWmyBj@shell.armlinux.org.uk>
From:   Stefan Mahr <dac922@gmx.de>
In-Reply-To: <YvZswfC/JhkWmyBj@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I4qX4G9toiYHXbKcgn3DtX+KDc5a0WCkPqtpRIs4lnvc+JDGrBO
 /9NJa47dBGy47NxiaW1yBicECEg9zhPrlsdLwx4PQjOh1ZziNShUR9kDfxd0O07CbEqGAs4
 vy8unNlSUhBdUwd+4ZGrh59QgwJZtVkw2sqIU/Lkeu50oFV8rEEOgXFIQ6pzuHCYGhKvrLw
 UlZy0lRSN18qDUimnShdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YSUK/ymvG5M=:NwvKlbV38xYCEvz5qLXhxq
 6TyCh2nO7ZPorxy86qYa78rNQGmHoIDSzudJ/wV60I3jkkbPy6aIpjhLdi5Vv0IvdKMzw3mr1
 K4u/ODBB+N71NZ5RxnSJPuw0uMKwXx0fIv3mhJo/aiWn2Lo1C+okeVecQGolJGoh4qF99Piiw
 B05w/+t0dEannfxuUkTqs5RayXMZ0YNKThZthflL/cMaHAzAkac9D00/hGp5Uuoym1o8DZVMV
 6+pJmiK8aJgqXIrG5QDh57AimuzqMCwXn5NlOjzcvB5O3khK5PMBA8h28QARzyZZfX05XzMLi
 ePAnbQDUZviEDu0ABkzRMSpXFqiw6VRMvHNhS3+zLVLsaI5in9jBxiFHsTkrFiXDF/Yo5FUjj
 NfrYCsHCMqybjBBoZM5IX74TObooHMB+kNhb4yxDt7F2lkibzWD8opYTAzyXY6qrhGkheCGvM
 sprae7nFFbNfeBfD6dP405M7g8XGxdpg1iPj+/lP+T/y6+Bm4/LSm8IGwpIaQMkPNgLmuCrs6
 ACWw1qCXHFUYQC8qkw1MssRKVWhO9ETDGojcZ3yx2PsFTD+18US5YClBvPQjBulDQP8KKteYo
 GlvvfWW5zr0+DgoZbzkhz4zxt/XUSiHtUfUOrWDS0Tpm8U/Of+RpFW6qRt66ozxro4f2+2DG4
 YwcLC5nd3S7yBaqyz0UGomAf/06t79oErxC/+APDC6h3dUbFHnKDXGivVNZrAtpmCy32CYc7x
 3ZBjPxiqsEMOcbGP1NpnfgBr7cX/YgHBYW9n+JfyD9oW5G/Se+RMmUyKk4S3/R4U8BdCl1SgU
 KNHPXvLk0l2TcUfHxpurPEWzQnZl7Xu8M+/1vMm7/ogF71XwKaUHVShgPBn/Mvw6WvopKxKg6
 +M7unLFEImWfyZXWaXaUo7BWXPUux5W4aSxx28JiPvKETpjcflPh8/AHqDUHmOjpIF48tQJKP
 PhKuX/NtqUfsofqeEYq2AavkScNl7QCdWGFBxLh1kFq3snyJ63PE0uq6NijYwFM3ccfp4nJL2
 8Jnx+d8d1S/6K4y59LZIlMuOusCW/kwFGLf5von+/NQsB+zQ5+ozYk6xg2077p5/lWkrnEDzX
 LdDp2VuFaM9NgnMvEAYfNsg6MJuNeiG7Pl7DHlvbwbcvo+SdrQNdn6ZxQ==
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Aug 12, 2022 at 03:04:38PM +0200, Stefan Mahr wrote:
>> This patch resets the fault retry counter to the default value, if the
>> module reinitialisation was successful. Otherwise without resetting
>> the counter, five (N_FAULT/N_FAULT_INIT) single TX_FAULT events will
>> deactivate the module persistently.
>
> This is intentional - if a module keeps asserting its TX_FAULT status,
> then there is something wrong with it, and for an optical module it
> means that the laser is overloading (producing more output than it
> should.) That is a safety issue.

Yes, this behaviour is not changed by the patch. When TX_FAULT is true
persistently for 5 retries, the module will still be disabled.

>
> So, if the module keeps indicating that its laser is misbehaving the
> only right thing to do is to shut it down permanently, and have
> someone investigate.
>
> What issue are you seeing that needs a different behaviour?
>

In my case two different SFP modules (1000Base-BX) indicate short
TX_FAULT events for less than one second and only one per week -
sometimes more, sometimes less. So the idea was to reset the counter if
reinitialisation was successful, so rare single TX_FAULT events can be
ignored.

However, you are right: If a module reports TX_FAULT several times,
something serious may be wrong.
