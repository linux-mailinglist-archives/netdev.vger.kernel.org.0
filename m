Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CD425164B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgHYKJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 06:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbgHYKJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 06:09:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7EBC061574;
        Tue, 25 Aug 2020 03:09:56 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598350194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2XGAM0PRYR03SuJTc/bHX8K9/smJPL4iFCLpG6x1/0=;
        b=B5xhdq/UJsHzxebd19FJ0qJozrHSlmbQnOPPNTeXA2DoQqrictbJvS0xpHRRIm+E2ZExhL
        wj6eIr2Wu1aL7kyEDHs0bLFzon1L+MwoZv+L7VxYDlVOrcyG7cajjrAIZusl7VMR4tf9hI
        cXdc8nGVX5tr4mg/CBRrxpo/ClJjbOqT4dMQ1jj9ekx9OkO92giK0Ea+1vhhJ2bQKoTTnN
        mWBDKTuzHCa802Jza7AQo28DlYNaIxJ94jBUp2cVSANpcKTpbZ83XNJEf7MFdPoOPXL7uC
        sfM6kH5npB37cS3SR+f72HeRj27vs41b7DHHKsiYwPggyhFNfLcxeTuJmtUGsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598350194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2XGAM0PRYR03SuJTc/bHX8K9/smJPL4iFCLpG6x1/0=;
        b=OCzxKklhl/duYKljVNR1MFLPdAEGtchfDape/0CkgrihyRBU5DLxhVUOln5U4XK6FB7Bhe
        7sD+VKrq/wCvydDA==
To:     Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20200825094612.ffdt6xkl552ppc3i@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt> <87y2m3txox.fsf@intel.com> <20200825094612.ffdt6xkl552ppc3i@skbuf>
Date:   Tue, 25 Aug 2020 12:09:51 +0200
Message-ID: <87v9h7yr2o.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 25 2020, Vladimir Oltean wrote:
> Hi Vinicius,
>
> On Mon, Aug 24, 2020 at 04:45:50PM -0700, Vinicius Costa Gomes wrote:
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>> >
>> > With TAPRIO traffic classes and the mapping to queues can be
>> > configured. The switch can also map traffic classes. That sounded like a
>> > good match to me.
>>
>> The only reason I could think that you would need this that *right now*
>> taprio has pretty glaring oversight: that in the offload parameters each entry
>> 'gate_mask' reference the "Traffic Class" (i.e. bit 0 is Traffic Class
>> 0), and it really should be the HW queue.
>>
>
> Sorry, but could you please explain why having the gate_mask reference
> the traffic classes is a glaring oversight, and how changing it would
> help here?
>
> Also, Kurt, could you please explain what the
> HR_PRTCCFG_PCP_TC_MAP_SHIFT field in HR_PRTCCFG is doing?
> To me, it appears that it's configuring ingress QoS classification on
> the port (and the reason why this is strange to me is because you're
> applying this configuration through an egress qdisc), but I want to make
> sure I'm not misunderstanding.

All the TSN operations in the switch such as the gate control work on
internally on traffic classes. The traffic class is determined by the
PCP field on the VLAN tagged frames. This mapping is configurable via
the pcp to tc map. And the TC also defines the hardware queue.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E428ACgkQeSpbgcuY
8KZc0hAAr/UQ8m5ytLPc9yAbCd4YGVVarPVv51+QvlLmAksbFekiCE26OST4oz/e
eF5RUqYF0vejPbj2ykH/Bs5TZO9hdsbU+AHLdtgu+X+PB5288QBoD6wk1tq2WEpB
2Jj5ppoQMQMQdrW8aYh63MBIIyfS8PBFqndWGkO09vCR7LEflnRFYlsl5qNWM91Z
GvMpNHkqWrJx2nRz1j9NH2J70m8RKeupsWD4RjxJFL+LzFXVfCTWb2Pdgd7PUQ03
T/SXCVSrMfT1Pc7AkB9SXynDC17VFUeQFmmQEpIvST9UGCW47d0kB+XSl9Mzh6zJ
qg/HJ6DiKMCT9qtPpcTZXGDXe177TqxeuIvTj/554j/rhA/g5rU+ezJhljUt3jK5
CMjBxUYbG1S99TL0ywyfxcF49bIJFIfJvoQuAR1QLUShfEiY/7SzDFh/0sRkYVTz
JF0IzVxHE9rvT1k1DcUrdLCD1Q4zRrUKiHIeY6Z8cT2jbp+ZnAAMe4+k4/c8E+k1
cjlEylnSwqjvwYruaIyggHdolveiOOaJ8M7E+7KPrUk6yur1EI1eU2i0/vty8mqu
bfU4BsTqrTZGSQfjH/zu8e2Q+62wEjsNLHa4Zy1s6cN1Y4kH7AhR4Bgo76noTJTF
4HVzxhQB09PwMhsqprKbrh6xdEQwcWpcoccFrrvy28iCc4Fo4GY=
=DRuD
-----END PGP SIGNATURE-----
--=-=-=--
