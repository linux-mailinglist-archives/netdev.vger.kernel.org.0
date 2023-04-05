Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CF6D7947
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbjDEKIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbjDEKIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:08:13 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B64C13;
        Wed,  5 Apr 2023 03:08:11 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3357i9Qk000359;
        Wed, 5 Apr 2023 03:07:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Dl7N+TmNm+nYUI2DLbSFtq1RhTuNc6Ge8tjld4dMPfY=;
 b=LrQVqiC8EtglXGmPNVVATOqbRoL2lt0irvadEm+ojMO0TIf1Fz09+wVp0jr3gJLgOcXj
 lGuQc446Ti72d7fqFOPJeN3p55rcbQOj4bxANakDW4+5DnY/cPJ1y2Wc8j40o09ZsQ3n
 +DMLJSPyG/UUBJTGEDPdvHTl5yqI33EkBfbgvQbgQExkRvkBfxgaC5MVuiMk0zoRg4JQ
 1qH4i8qYD8J+QxCPK6p37STO43FcZazuxunerwQoUpUpwPP3QbdnbE6F9sEEt0SZ/gho
 4Z9XyjrbiAQag2e+gY9pdsxNvgVnKfC2g/LjyU9t3WZBXbnA+T1x4zGwB9+fLaT0aM8O yQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3ppkv935h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 03:07:35 -0700
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F2575C0445;
        Wed,  5 Apr 2023 10:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1680689255; bh=Dl7N+TmNm+nYUI2DLbSFtq1RhTuNc6Ge8tjld4dMPfY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=SR2g4AajU1MsOENd2K2/c9/RkbLsQTwenrE7Ie/7W8rn/B6saIjN+oV8S3otB1ABh
         ReZH2IRnfkiD/3UOJz21VszzbhEiymWFCOT90YTslli/9nGlkuQMwDpj5PuAbl6nwC
         8f0Pl7hWrsLW9tN7uPn0hJvgwCmC0Ew3s01L2ofyzEICwRPlJ4g9je8jfu6VSdcVYN
         O+OaofDq2/ftQhusUYV2sjdstCIyGDmAgQE8KC6JD8CoQIdfeBZBadQyVH1My8dv3Q
         pIkKBny3T+4nYztVZEyIRMImGgWppCowftB6oWeRGFIwg4rVogibCB6kJPVBHkQ/uf
         YRjJJJHCi0oUw==
Received: from o365relayqa-in.synopsys.com (unknown [10.202.1.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relayqa-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 45738A005C;
        Wed,  5 Apr 2023 10:07:28 +0000 (UTC)
Authentication-Results: o365relayqa-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relayqa-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relayqa-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=K8zs84Vh;
        dkim-atps=neutral
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relayqa-in.synopsys.com (Postfix) with ESMTPS id 55AAE22028F;
        Wed,  5 Apr 2023 10:07:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXQTt6ClLqM972qf6wYIoH1I8xPqisc9W9pW03ie0BpB4Mg23qisGRRqACoTlAnvzo0rEbCcdjCzfTdS3yJGZ5KxbWflbZLCqCYJsCu5osRk3i+/etPfOdxCl1WuitSPRQ1guX3u7rfPFPZr2sATn1VAuw1S88OBNb3iDQSBuHs8tLbeHMqgaXfpwdsxd4+bjeFuL0Sn3HJE4g+HUJ447D5U8/bEPEYCxQRbgXxyQIO1PIJudTtbTPHn485fYDGBECTHsj3NFr+vC2UQWjD8Z8q9QSICiMPfx6oejgIGVsMJ3s97aTNflWHnN25XbmmFet/gYjuFxsuVH3TIi8Bltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dl7N+TmNm+nYUI2DLbSFtq1RhTuNc6Ge8tjld4dMPfY=;
 b=kom7NddeeK0LElHbEDG3DpRhhNA3V8ODoxXSWhfgLkJBRCIytijecw6ch1j9myvAiJMy9Y/2dBoPmBj3pOos7CVUbYbDSsy4fBqbMs099TcNjCl46BS7YMV8c9LuhIp8EsCJtwlfMSmUaxEgt3G8YKx+utQhesXgK174U68Ly/X3D4zWawmDHPVHNeEQ3IicuYvHv511kpO9sicAf/veCU+qYVjzThfhPBw55ZTehofqM4+Hrg3Y76qNsqKmKeRqx90Egs1Le14d1uqxYR/sAXsnz3xUn2z8vCht78v8aB6lSSB/YivY7qU9gIfLWeyvZTX0XL87rnys5ijXl5170w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl7N+TmNm+nYUI2DLbSFtq1RhTuNc6Ge8tjld4dMPfY=;
 b=K8zs84VhVZi9LVQlrgriyzv2H4luogWhBeZbBHC2qhC3kGu547waFUuy1oCVGv6x3RyjXHvhrE0X2SFP4/TgbtBgqrtcWaIaR9EtN6uE11z0WdHzb+BJps0JYRNAlc0QJ09EUtnTafnbRpjE1qUP+/GPFEyeq5Gk3FpYRZN+ffg=
Received: from SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19)
 by SN7PR12MB8820.namprd12.prod.outlook.com (2603:10b6:806:341::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 10:07:22 +0000
Received: from SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6]) by SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6%4]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 10:07:22 +0000
X-SNPS-Relay: synopsys.com
From:   Shahab Vahedi <Shahab.Vahedi@synopsys.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "hock.leong.kweh@intel.com" <hock.leong.kweh@intel.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>
Subject: Re: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Topic: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Index: AQHZZ6K0q6ehNDvGEUiMYWCtPaujMq8cfZ2A
Date:   Wed, 5 Apr 2023 10:07:22 +0000
Message-ID: <ac972456-3e0b-899f-1d84-ce6f11b87d27@synopsys.com>
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2782:EE_|SN7PR12MB8820:EE_
x-ms-office365-filtering-correlation-id: d3f28b74-4d97-4d33-992d-08db35bd8c46
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CytkwWCqevay/E8kcInNwLIVxs1ZoRHDFWdVbbO9s2FO2BxmAZLIQLtNFgGRU1egZ/VNvjM46JsB3FnxdU6WxhjRbwfSq15sjZMcYl3TaGOTG8yU0omPn/jY7g3okWkWdK0wxopsLpcCkBbwlthARufQc68ILuFc7IfdPDQyybu2q8w9c4gXrzwColDAJJREmGrBcXkTjy/ePAuxuUgcIRpLwDYbfXADqZyinbCLeV/081XEJgInZj0D8fDGTur2ux7+8dZy40QmN1v52D4npHhfGRHZhfDGccyQ9klV/KjZ2ojTblim3HqWV9jpEuRJeoRAEgvspRf0qSGTyHlLkw9pz4bipw9wqIQhGCoXgtkOB/UwjjDfplraia4dYA28RVcJXDbJGaYYKk1YWmA48FcP7h+EhcYACSekF5x0pu2CV2gSRh9/DhlIilhygfRaQB6Jxjcv/5277KDg1narm6nDy9ebA8wI91+byro6x1yqbRSB+9yGmNkzNz3q+SRCfH+MnM5J73TIeLRHlPdE9e4RctuK6jIGvHE8Zfb8btd1di2Cjf9lTefGETqMLGMiHbIOtsPCxY/a9lJEzFN7tOF0tJO4V/R8kgHbTCz4R6VWJQnE6G34jwXwNpDYDMx7aNSoIIT9w0qYzztLDHpi0AcnnQUxeLwQPWI4eqFR4P8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2782.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199021)(478600001)(54906003)(316002)(110136005)(5660300002)(8936002)(38070700005)(36756003)(31696002)(2906002)(4744005)(7416002)(86362001)(4326008)(8676002)(66446008)(66476007)(64756008)(76116006)(66556008)(38100700002)(91956017)(921005)(41300700001)(122000001)(26005)(6512007)(186003)(6506007)(53546011)(55236004)(31686004)(66946007)(2616005)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3RBWERSWkI1VWdZNm8weDlYc2xGM3FLdDdPWS83YndYWjV6OXkramVROVF0?=
 =?utf-8?B?UVRnSk9RbGhkZjM4b0w2WDVXNzhHMzM0UVc0VWJ6RGJ4TEsvYTY5empQTHBk?=
 =?utf-8?B?MW5Td0gydHNlVjFTUHFmOElnQU9xQVhndWh0MGMrRkE0MXdzdTlRRXoyc01N?=
 =?utf-8?B?dkJsaVVWS28rVi9PcmRHTEoramZDSU04dFVZRTA4Yng1OW1GKzZWaW9KQkRp?=
 =?utf-8?B?MkIva3ZWZGhSZHBUNjJHWDBuZ1pUTDRoT3FEbUNrV0Z5TkxQU0lxaGlKUjhD?=
 =?utf-8?B?RzZqR3ZUV2dCQTh0djVaNVdyYVFZMEdNdEpWSlN0Yk5xQ0JuUnE3TkZnNXVu?=
 =?utf-8?B?dzB2OFNrNi84WlRwWVZmempacGxKSHJXNTRISnJ3OVJZQXZ0UHIvVy8xZGhx?=
 =?utf-8?B?S2dmOHdNcjdTRC9DQk93MjZxdzdBTzBTU2Jrd2hHS3NKRnh5bE5qMEQ4ZXFm?=
 =?utf-8?B?OGV4K2JLeFhvVGxNUkN5VTFyRWJReWltZUdldzFaMXdrVDg4aFh1YldvRUJp?=
 =?utf-8?B?aGJkK0tvSXdWQm5iVUMvbVNBTHpTTTRMSnViTTR2OTJUcmJUWjRDMGQzU1Yr?=
 =?utf-8?B?RENjelZLTTEvMlIrdzF5TGNKRVU5QW1vK3Z1UkYwb0R1NS95ZFZ4b0FhSzVw?=
 =?utf-8?B?enBYbThoS043cDBkcTNlaGZxcHdjZEZMRHd2M3NOeTJrQWdRRytFZ0JHb1d2?=
 =?utf-8?B?WG5sRFJVdEgyNFpXaEI2NFdlOG1HSnRKSk5IT3VhZXJWejluVjUra2VCWCtv?=
 =?utf-8?B?c0swRHJIcFVTNWRwUmlyN0Jva0N6U0QyeXprdlZ3ZkRadFpqNEVhaTVXUkg3?=
 =?utf-8?B?TjRmd3EzenU1UEZSSi9lYXNxcEpJZ1gyVnpYNUQ3SFladjFTZEZPNEVNSnMv?=
 =?utf-8?B?UkVSNjY1Kzl5N2xDVGt5QUZLSy95VDI5Ym9rM1JQci85NzBQaW1ISHFRY3pP?=
 =?utf-8?B?enVncTNXMTdsRWNuaFFSV0Y2d2FWR2I2dlpUL3lRL1NCL2h2c2ZUQWQ1ZFkz?=
 =?utf-8?B?R1pFRmNvRGlYdUJLS0tJM0xkc1MzWUtaa1FIN2ZZcTFNWWsvZ0NBTXpQTHZ6?=
 =?utf-8?B?NDBzc1BzR2FsSk00ZHNnNjREWllaU2ord0k4dk9NMDlPSlBXMVJBQUhWNlVI?=
 =?utf-8?B?dHhDdW12RUdwMmIvS0ZmS3JHOHl6UlcwREZLR3N0VjBFNXBpRW1qY21ONVNu?=
 =?utf-8?B?UmYreDVQSzBvN2RBc3BvOXkzM05wSXhKUDkvZTYwTGVsTW0xZzh6bGFxUXRZ?=
 =?utf-8?B?K1I2NEt2c2ZwNHJmL2QwY0Z2cVd2SndHSWxWYWNuOEhxTjZkSjNzZm0wTFhK?=
 =?utf-8?B?eEE1aUpnVm9kWk9YcjFoUVBLNlVqQlNVZlpid0FiZndvYXZ3TDVva2FNbXM0?=
 =?utf-8?B?MUZaSUpZbDh1dTFmVU8vUDFkZnczYVdXMWxBNmQwRkErTElxOTlTdHYzTEtR?=
 =?utf-8?B?UVJ4ckZ2QXdQditPdWwvUURQVWZKa2J0L0REM1BrWXRRMXFZQjFJTko4Ni9X?=
 =?utf-8?B?N1VobnVqZlh5UEJGamJCczFyQlg0U3ZSNkwxdXozNmxnNkE5M1FSVGl1emZz?=
 =?utf-8?B?ZVE5UUJ3UXdjSDgxZkFQL1g2R2RyM1B5TE5hVDl3aTdMZ0c5QWF0ZHRjWGVU?=
 =?utf-8?B?VjRHekxmaXBoTldQMUhqUlM1MVZvZ0I0T0pRcUIxT3lIR0cxZ1hCZkEzMUN6?=
 =?utf-8?B?dGV0cGF4a1lWVlZjQmU0a0VXSUgrVEpQOHZXc3AvSjV1WnkyLytGWm5KSy9E?=
 =?utf-8?B?MklFT1N2UUFQWUNaSGIyM1FwQnBrMHNsQ0RoMUNBWHZMK2J0bWErZ0U3dUJ0?=
 =?utf-8?B?LzhyczZneUt5QnZ3bTVOK1NxRXFxSjJ5MGdqUHNBdDJZWnU3Q2lycXg2SFB0?=
 =?utf-8?B?QTdvNG05K3FFRWpkSFVZWG5xdDZVekNLc3dsUUpRRDVhcU5tT1dOaFI3UFJx?=
 =?utf-8?B?bGI3OFplcUltdDhYV0daUm1IY1NFRXc5Y2N3YTZMNktPU1p2M2tpbXFWcVBw?=
 =?utf-8?B?Um9ZYTN1WFFmK3VPcTdzREJ3cVp4dFg0eW1qcWlxSFVPMnYrclBEUVgxMStX?=
 =?utf-8?B?c3I1MUltZzJyTHpML2UwVnZzUzk4dkdEQ3VIeDNQRGMyemRoMldJL0lvTVdq?=
 =?utf-8?Q?ZK+k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0BC39CA721F734290B2604DEE7148CC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dmtqMCtPYW9STHpKMENvWGNkRXZxbDZHcjdnTTFTejUwSUlsekttdjlScnA5?=
 =?utf-8?B?MjZrTk4yQllKSFlaeHNNcWM0dmhNdEEzL2xnRmRDdDFTOWlOSVYrYXhVQkhK?=
 =?utf-8?B?TEErV1k2VWVWTnBad1hpdFNLaWFzL2JWL0U0OURtaDNQeEt1d0M5MmJvWkdE?=
 =?utf-8?B?bm55VzdWRS9qenZwVG9udFVDTHV0WHJwV1JxQ212Y2FuRHZzemtNeDYxSDVC?=
 =?utf-8?B?MXJLQmhTQmF4R3dJdmF4dHhYSVlxcUFkeW1sc3pPUitSYmhXcmozdVoremwx?=
 =?utf-8?B?R3FoTHNybmIxZVk0SFRmWThzY2lpZHpaaDh1aytyQ2JwL2NGV1RLRWFuZVIz?=
 =?utf-8?B?T2c3V25OZWhVbFh6S28xZnZUWE1GajZjcEZmdnMvMTJGN2FzRGdFVk1MZTl5?=
 =?utf-8?B?TG5zOGY3b2dteHl0anY4SFo3YUgrUkM2OHY0dWdOaEhwMTNSUUlrZG1hQXY1?=
 =?utf-8?B?U0xrZTF1WXM0dDNNU1VxYjhKVHNFZlhIRXhUS2w2bjg4a0ZaeVkvUG4yUkc2?=
 =?utf-8?B?RVZZY2Y5cmRTd1JqeTBBRnFoWitpZ1VrMEk4alZwMnpqSkpSOEQ1Ym9HeThH?=
 =?utf-8?B?RExSQjhBa1lwTk52ZHlFaFZ4RWlybitWQ1E3OWRFKytRNndmRXFhMGxlQ003?=
 =?utf-8?B?YnkvcUR0OHRpc0paU09sRXBwb1hmZVFoZ2ZaSVpOekl2b1FDbmF3Mk5rV1Q0?=
 =?utf-8?B?NjlSeUo4dUhPdngweEU2QXpFRXdNTHN4V2RJV1lsbHJudEVEN1dDdmo1NUd3?=
 =?utf-8?B?QkRCRSs4dkNSRk5YenYvUU5Lb3VGQnVzSTZvWDNPd2NpZStnUXNjLzh4Yll6?=
 =?utf-8?B?Q3RMdFA2VDA3RWMvb1poNS8rOEw5QlNjTFRXcEJJNWF5aUgwYXFIcm02bGRq?=
 =?utf-8?B?aDUzYTA5eWxldDJyQURwSTN3SldWUzBYOXZyczdvWUxBQitnVzIvTjFlL2x4?=
 =?utf-8?B?bklubm9ZazRmMHNYeStLR05mbzNScXg5TDNPbjJZSXNLZmp5M1BRVk5lUmdQ?=
 =?utf-8?B?b1Vnbms5S0M3QUM3T3Q5TS9jVk5TaXJOMkFrTFBtbWVZcW96UXNCMkowQ0RX?=
 =?utf-8?B?SDA1Uk9NWUZ3aDV2STUyR1dTaE4rNGp4bitWTjFiMWRWK1VJaTFrTFpYYkx4?=
 =?utf-8?B?NUtqUXFnS0hRY1BqQmZzVDU0SFcxYVl4Z2QwcDFoQWlZaEl1ZkJNVnBaYkps?=
 =?utf-8?B?STI4cXcyS1V3ay8xaHRoMmhPc2VsRGZQcVFnY3k0emR1T01XRjVUQk9IMXRE?=
 =?utf-8?B?a1ZvT3E5Mis1NGs0eS9HaDZZWXNjZzBFU084aVVyRGZDejM1TVJiZjc4allD?=
 =?utf-8?B?UG9UUlJKOXk5QlNMeWgwWDFoanhVbldIbm4reHN2Q21MS1RoZ3poODYyb0N4?=
 =?utf-8?B?cDFYQzBteTdta2tUTEVZMzdqZVQ5b2Vjd2M1b3BSSU1FS21xU3pieENnZ1ND?=
 =?utf-8?B?dTRkeC9pZVpjR2I5MmllUUQ0TVc1eUg1SFRnVWl2N3NCbnBuZmpaNFRqMDFh?=
 =?utf-8?B?eWdTZjhsbTU1S2dLRnRKRVRFRTZiajVCN0lFa2ptd3BLNTZxQ2lqWG9QYXo0?=
 =?utf-8?B?YWkyZVd2VFd1Q3NMaDlmOU9BeHNualZ2MFR2MlY5OWp0Z2NvZ1haNG9XWXQ4?=
 =?utf-8?B?VjJBcUlab0RoelkxMVlOZDdwbEh4T1JieXJwbDJEUjIxbythYmVmSkZsSXps?=
 =?utf-8?B?U3hzYmJJajVkRDk2R296MzNjVEZxQXNNUEFhU09uaVorQUNYWTlFTlJIMTJC?=
 =?utf-8?Q?JNX+FxEYbnW2E648ww=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2782.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f28b74-4d97-4d33-992d-08db35bd8c46
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 10:07:22.1461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1fjFw7dWNF3mWzhEeJhSK8UMd5+OpCxR5DDDUiGkfRnTVrBUsFs+ngkJd3BltwJHvNKSKmc44I5kWN52yOLpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8820
X-Proofpoint-ORIG-GUID: 168VoxPGxIk1x6uf3t59zAsrOVkskHjj
X-Proofpoint-GUID: 168VoxPGxIk1x6uf3t59zAsrOVkskHjj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_06,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 suspectscore=0 mlxscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=512
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304050091
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC81LzIzIDExOjM5LCBNaWNoYWVsIFNpdCBXZWkgSG9uZyB3cm90ZToNCj4gU29tZSBEVCBk
ZXZpY2VzIGFscmVhZHkgaGF2ZSBwaHkgZGV2aWNlIGNvbmZpZ3VyZWQgaW4gdGhlIERUL0FDUEku
DQo+IEN1cnJlbnQgaW1wbGVtZW50YXRpb24gc2NhbnMgZm9yIGEgcGh5IHVuY29uZGl0aW9uYWxs
eSBldmVuIHRob3VnaA0KPiB0aGVyZSBpcyBhIHBoeSBsaXN0ZWQgaW4gdGhlIERUL0FDUEkgYW5k
IGFscmVhZHkgYXR0YWNoZWQuDQo+IA0KPiBXZSBzaG91bGQgY2hlY2sgdGhlIGZ3bm9kZSBpZiB0
aGVyZSBpcyBhbnkgcGh5IGRldmljZSBsaXN0ZWQgaW4NCj4gZndub2RlIGFuZCBkZWNpZGUgd2hl
dGhlciB0byBzY2FuIGZvciBhIHBoeSB0byBhdHRhY2ggdG8ueQ0KPiANCj4gUmVwb3J0ZWQtYnk6
IE1hcnRpbiBCbHVtZW5zdGluZ2wgPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb20+
DQo+IEZpeGVzOiBmZTJjZmJjOTY4MDMgKCJuZXQ6IHN0bW1hYzogY2hlY2sgaWYgTUFDIG5lZWRz
IHRvIGF0dGFjaCB0byBhIFBIWSIpDQo+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgU2l0IFdlaSBI
b25nIDxtaWNoYWVsLndlaS5ob25nLnNpdEBpbnRlbC5jb20+DQo+IC0tLQ0KDQpXb3JrcyBmaW5l
IG9uIEFSQyBIU0RLIGJvYXJkLg0KVGVzdGVkLWJ5OiBTaGFoYWIgVmFoZWRpIDxzaGFoYWJAc3lu
b3BzeXMuY29tPg0KDQotLSANClNoYWhhYg0KDQo=
