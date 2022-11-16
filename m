Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F1E62B33F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiKPGZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiKPGZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:25:17 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C7D1DDE6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:25:16 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221116062514epoutp04e30b7578fce89345cf3b089dc69f17c9~n-JeIuS-L1506615066epoutp04W
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 06:25:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221116062514epoutp04e30b7578fce89345cf3b089dc69f17c9~n-JeIuS-L1506615066epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668579914;
        bh=qWpc8qcl6AwBZWNvnl+aNRw7/66rtCCP1RYlKzpi1rQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=FFBLrsKVxPw+bD8lIUJrgbbpjYJJcH0r/9iKDw8/rxzoY9TD7/T6CeI4KJqvK8nX+
         gQXL9aaNOiYiFZ66medO+oAv7iKhM62INUS3bWEW2FksmVs2qxPVjDg/N12lNsnXBf
         UnBYxZ9H1cfYAHx+0DtocvmVvka1cvKaQtdixfbc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221116062513epcas5p32ce682c3909c593bc6026d32fdb2c951~n-JdWALtG1579815798epcas5p3e;
        Wed, 16 Nov 2022 06:25:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NBtMC6F1Lz4x9Q9; Wed, 16 Nov
        2022 06:25:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.48.56352.74284736; Wed, 16 Nov 2022 15:25:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221116061735epcas5p2dc6b5e49a6794c1b2171bc75a9789a1b~n-CylGthA1186411864epcas5p2b;
        Wed, 16 Nov 2022 06:17:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221116061735epsmtrp17832c3949fbc652bae12508b13e3f78d~n-CykHNa33179531795epsmtrp1l;
        Wed, 16 Nov 2022 06:17:35 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-33-63748247a2ef
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.11.14392.F7084736; Wed, 16 Nov 2022 15:17:35 +0900 (KST)
Received: from FDSFTE302 (unknown [107.122.81.78]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221116061732epsmtip14cd11451f2b9b8c136b91b6a4caa6072~n-CvvUOiA0670206702epsmtip18;
        Wed, 16 Nov 2022 06:17:32 +0000 (GMT)
From:   "Sriranjani P" <sriranjani.p@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>
Cc:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Jayati Sahu'" <jayati.sahu@samsung.com>, <ravi.patel@samsung.com>
In-Reply-To: <82801ce8-3a25-3174-65bb-239875065761@linaro.org>
Subject: RE: [PATCH 4/4] arm64: dts: fsd: Add Ethernet support for PERIC
 Block of FSD SoC
Date:   Wed, 16 Nov 2022 11:47:29 +0530
Message-ID: <04ad01d8f983$1e770c20$5b652460$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHa0oM14/tprCIIIJ9eaP02I486nwEn6ORUAXidpdkB2+iDwq4ZfYRQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1DTdRjH77PvfgEtvs4JnxbZ+l4/DhLGcOAHY1Rq8jXq4tCru6xojS8b
        ML7b7Tv80dXJaQJD5VdhuFtK/FLghIJNhYECIRyCZmloQgQIF8L8EXQcU4Q2Nov/Xs9z7+d5
        P8/ncw8fEy5xxfxU2kgZaKWW4Pqyz/wU/Epo3H6jKry7SYqcd44CZPn5KzY60XWFgya6x3io
        61IlCw2X3+Og/MlRDLVN23jo6pl8Dmq8PcBB11osXJQ3MM5Bxx+f5qDusgA01+cAqNz2Dw8t
        TdsAGn3Q6mrSP4mhg21dvDdEpLXmdxY5UWDjkc3mP3hkWWMm2Vhr4pJDA61csqlyH3n//G9c
        Mt9aC8iO8zJyYr4NI60XZgE527g2QfBheoyGUiZTBglFq3TJqbRaQcRvT9qcFBkVLguVRaMN
        hIRWZlAKYss7CaFbU7WuXQnJLqU205VKUDIMIY2NMegyjZREo2OMCoLSJ2v1cn0Yo8xgMml1
        GE0ZN8rCwyMiXcJP0zUTzilMXyTYk+ts4GaBo355gM+HuBx+d3JXHvDlC3E7gPllh3meYAbA
        63WjrDzg4wrmABy2K9zsLnA4ir2iNgBnDvWwPaK/AFwa1LmZi0vh9KkTXLdIhFexYF3+98sB
        hh/B4I2TxcDt7YPHwqEF6C5Yje+E9x7WcN3Mxl+C1SWLy84CPBr+0H7Zy6tg77HxZTMMfx6e
        vWvBPBNJoHOimuNmEb4VPp6r9moC4UXnYcztC/EKHzg0NMDzFGyBhd3HWB5eDad6rN68GN4p
        yPayGjZ1NXE8rIW5+w94zV6H7dctbPf8GB4MG1qknvRzsORSPcvj+zQ88mjc214Azx1/wi/D
        ijGTl4Pg6bEZTiEgzCtWM69YzbxiBfP/bmWAXQueofRMhppiIvXraWr3f/+t0mU0guVLCIk/
        B8ZGHoR1AhYfdALIxwiRoCrLqBIKkpV7P6cMuiRDppZiOkGk672LMPEalc51SrQxSSaPDpdH
        RUXJo9dHyYhAQUVpiEqIq5VGKp2i9JThSR2L7yPOYq3Vf9w1MLXhVoNxzRdz2/a2d6RdnRdW
        fDZi2+gXVFnlCOBsj0gNWTiVrfAzjTd/1OwvVC/MXriv/ib1295rLTn1HTtuOmLEBXE34qq2
        2a9YUgLHEgsPRK5a+OTXoWE/q6Jo8JHI9DBwvMY/rsfueG123Z/v5uTe/Lr+4O7b+E77W77l
        v7xaWDS41FtroS9/eSjlxxfv1klKzQYptlQdgXLRs31OU9v8+/bYlKCnguVZfR3FFW/3XyzI
        VncGB9iCqJLWpH36NFvw383xIyJfS+IwnVg4rLHWLuxgzo40+NtKHXpTqXhx8c20zZN7RuSD
        eH9MizWl5lY5Lh18YdMHqpx1Ie8RbEajlIVgBkb5L+myFPGSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa2xLYRjHveec9pyVytHVvDZGGhO3XSoSL+YSSzixJa4JQ9B0Ry3Wbms7
        jKCRTaamRmahma2WWrSZbLq1NbuaKcMQbDIbsdmZSzssZVPMpVPJvv3++V/yfHgoXPSBCKWS
        VVpWrZKlSPgCwnFLEh55VKeVx+SYJcj3vgCgwkdZBCpufshDnKuHRM33zBh6VfKRhwzvunFU
        57aT6LHDwEO2N+089PRGIR/p23t5qGj4Kg+5TCFo8L4HoBL7FxL9dtsB6v5c+3fkwTscZdc1
        kyvETJWlA2O403aSqTa+JBmTLYOxWU/wma72Wj5TaT7KfKpv4zOGKitgbtZLGe5bHc5UNXgB
        47WFrxNuFcQmsSnJ+1h19LJdgj2c7wOedkZ4IMdXzteBgrF6EERBegH0eM6SeiCgRHQNgJd6
        HeQ/YwpseW3G/3EwtPx6GwhxADaed44YfDoauq8U8/2GmC7HYF9uPs8vcPocDh+06gMVL4Bl
        lX1/BUUF0ctg10/obwfTifDY7V7MzwQdAUvP/RphIb0IVjS2BngCbLnQS/gZp+dCroML8DTo
        7C8MnDcd+rhSnp/F9Co4PFgayEyCt325eB4INo6aMo6aMo6aMo6qmABhBZPZNI1SodRI06Qq
        dn+URqbUZKgUUfJUpQ2MvMOc2deB0/o5qglgFGgCkMIlYuGWAo1cJEySZR5k1ak71RkprKYJ
        hFGEZJLwsb5lp4hWyLTsXpZNY9X/XYwKCtVhrduQb9rz7Iy4MaeXK1oTGXfuE5P0R9K6yIH5
        oBI7lVxhL+vk0AbPnajU1e71RVLnzIiwiOXtTQOJjWZtTc6n9Nl9Dme8607c3bVKcVYX12AK
        G2dxD8THvljcYZhyrLhSTqY8MsyYt4QQyF+sWRmZ4EpIEClruovCdQt15Ue0xT1LT876EpSd
        uik0ZGN4tOXQgk5L2YHv6f2ZnomTCWTYPV4cP5Rn0yryQy7CanzVs4Vg8/bysPWqr3GzVmJW
        Z2RJbObU2jwVuPbVUWGcf3bo8hWTJLYaDJWtSO8cFAzEMPks7vIeieg5v+Mg2lvd8dp7+GZ/
        Qtvx4aGi9M3BWRJCs0cmnYOrNbI/nuYZSH0DAAA=
X-CMS-MailID: 20221116061735epcas5p2dc6b5e49a6794c1b2171bc75a9789a1b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2@epcas5p2.samsung.com>
        <20221104120517.77980-5-sriranjani.p@samsung.com>
        <82801ce8-3a25-3174-65bb-239875065761@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski [mailto:krzysztof.kozlowski@linaro.org]
> Sent: 04 November 2022 18:17
> To: Sriranjani P <sriranjani.p@samsung.com>; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; mcoquelin.stm32@gmail.com;
> richardcochran@gmail.com
> Cc: netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Rob
> Herring <robh+dt@kernel.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; devicetree@vger.kernel.org; Pankaj
> Dubey <pankaj.dubey@samsung.com>; Jayati Sahu
> <jayati.sahu@samsung.com>
> Subject: Re: [PATCH 4/4] arm64: dts: fsd: Add Ethernet support for PERIC
> Block of FSD SoC
> 
> On 04/11/2022 08:05, Sriranjani P wrote:
> > The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP,
> > one in
> > FSYS0 block and other in PERIC block.
> >
> > Adds device tree node for Ethernet in PERIC Block and enables the same
> > for FSD platform.
> >
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
> > Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> > ---
> 
> Same comment apply.
[Sriranjani P] Will be fixed in the next version.
> 
> Best regards,
> Krzysztof
[Sriranjani P] Thank you for the review comments.


