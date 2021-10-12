Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C858E42AA37
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhJLRFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:05:13 -0400
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:33767
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232231AbhJLRDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 13:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2te1MNKTKhtD9qwL3z8SSPoT9VktF3hmRBJyjAFUeK9b6c+JPFbxQADx5NqGonD0ThdY1ubhvzFhjTQSYPze6edBlgKEjCNgjRGAOb86PHNVDkrezWE3sJJsoBmHuPMidmv5u23daHHK2FCAo8SwWiHYKZjdnYIvuzzsiMTwLhQgnOzor+RliW55nAjSxpLQHJNPju4mC1lICPk1L9yeHLRrm6pJ/E4uWZyAYdiKM0itkjJqASsERZgYEa2iBFBWUMQ8rkoevOe/53KkhNHbx4qrryS2UBa51Ts5QVniLI5DYV83lVyljDpQw8FHGdMIHcDZtgkxGgKkimG73nbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL5RxAldPnKoB5oqdujkjbOFv22ieq52kAtJzjTKuEo=;
 b=WYYSzX3Qo+Is4mSe9E9P7lhIt8HHhm42huC0o+jab0VkXY6bISGHagKNG/PiZ1P4JOTWvQsP39r1/RBn8O4QnMGGo7spdBMh4NDFSiN3BaJBCAqna69uaKtFyq5QTq/KQsFijaCAlz3GvJ85+yaRd01/RX6GawXrBsGxyf6ef3JhXirUwqlvf5TFGJVM62Q+qUkSIKSJKC9FRK+214lBFBD9n6hdTVLkjpBqmx/1DzUB4QWAupCA2LVHHZ8ouNbgEZ0nmwNMoSlXI+MAzHaPrcDgh5Ai7dnA/qGPtql1REOBD1XpXzfo004Se0+7zKHk5y3gfSe8QItUquby7JzzxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL5RxAldPnKoB5oqdujkjbOFv22ieq52kAtJzjTKuEo=;
 b=FzXm7zUuDED3qXfVvCCIe/9kCUPiDq/1XgmolRh8IBZBKHPWQb0lKFjRgWb5r25Ws3ItDjynhH0XUQwi4yP04/lvXcley0QhCEQjFagWbi+ehneZEod/MesZ+ThlI6rVHED/Uril+TPjyXwkbpIqECyLHnHF9pRSqqMIA8YPNUg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB6762.eurprd03.prod.outlook.com (2603:10a6:10:20b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 17:01:26 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 17:01:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
To:     Rob Herring <robh@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com>
 <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
 <YWWKuhn4FfgbcqO/@robh.at.kernel.org>
 <2e5ebf4e-bc97-1b8b-02e2-fe455aa1c100@seco.com>
 <CAL_Jsq+MAy8CRjLvqAg5oC53=ZO2UZcH_s0kMnaYD8M+y8+dLw@mail.gmail.com>
Message-ID: <ac2ceacc-db1d-ec99-61c4-f20e5d371fad@seco.com>
Date:   Tue, 12 Oct 2021 13:01:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAL_Jsq+MAy8CRjLvqAg5oC53=ZO2UZcH_s0kMnaYD8M+y8+dLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR15CA0062.namprd15.prod.outlook.com (2603:10b6:208:237::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 17:01:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea553fe-e996-43e5-4341-08d98da1ed6b
X-MS-TrafficTypeDiagnostic: DBBPR03MB6762:
X-Microsoft-Antispam-PRVS: <DBBPR03MB6762739A7FADB66A01D14E4496B69@DBBPR03MB6762.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KbEtEbjGiCmmRsFFIBCMwV59UM6r3NAK0JGpc4CeykEW8+5q3mLmdY6Pkx1QneqW4Xi9PLXps7wpXZnRB6+xidFRYRewWvbqkOG/BM0CjUqo1jxzI6Rg+QlW0EEhR00zP3q+vBZCUzMp6dE3qa2TJFKU46GCAtpiicTU2qdBpeGJ0NtU4WKrZXe0492CM8PyaXY/MPeXBh9fy/KpmiT5RAeQBL6YBVCIzP7CDikKyHmOxrIc0A9uNMDfi7v2PFGZSn4Y2RjLuWXJJsDupvCL5Lkqc81F3sfrH/R/XndwnFiRiPjioBbkUYc7f9uPyQ6VfrnHoq4ZJFPhMwalKoIquWDcRm0p51PzG+v6hNC8U5RxxsTSWbjWL7bJxSV6DU3R7fVGnDAUrWizIWk5w3uoUZkFm7uPf0oEtB2Y50RREEGBYXQIwTYLMUZXJh+reyaIqaNaMMYAYgp7D2Wjc4xu9qFup7a8Z///T1zDAhBwM9Yu3RPCna4W+5qEH17A7Xr2+dfxP+C/RxYY/VPqzj4l3wZdW9rtX3mPztQ57pTSswrxNaLGCZ0/Cqdo6PPkOez4G4Y03QHFHPSpcx1rzbtlRBTXktRmYtSeeRU9Sl1sa2N8sFw/TEpv3ICwE//+v3tmt8vt1Rz6IF4gwRFgbtBszoewKDb9Skv1vcPCAZ+XlTtuSy4QIXBYXugcdyBJf3ngrb1zi8L9rOoNmKyvpnxrZVTvBOuyXA6wCFfaJvSTNOMw3lto+8+URIADdY+0EHkIWspj9vaMABCW9LvBfo/9qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(86362001)(6666004)(2906002)(31686004)(83380400001)(38100700002)(38350700002)(6916009)(4326008)(44832011)(498600001)(52116002)(66556008)(8936002)(26005)(66946007)(8676002)(186003)(66476007)(2616005)(16576012)(5660300002)(36756003)(6486002)(54906003)(53546011)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UU9zeGVmSysrcG5VRkI0MGYwTmMrVW4rRHZpODNMQWVWajdxd2RVWXk5b1Jn?=
 =?utf-8?B?MnBUNWtWbWtQcGE2akVqdzQ1VnltV0cxTlpDYXI3a3JHMW1HakRvUFl5VVBr?=
 =?utf-8?B?NHpPVHBDVHBaT1BaOXBGU21Uc0dwT2pQdWdjWTlxMGF2cU5qcU92Y3NkMkNL?=
 =?utf-8?B?Tml5Tm5RcHBlWkVqY1l1YnVIVlJFUGV1a2JtNkthYVNsckxmMS9sMzU2RCtv?=
 =?utf-8?B?ZjBiWVZPVGRRYVdEMWxjV0RDaXJNbTh6aER4TTdNeEJpRFZvOUkwQmc0eWxm?=
 =?utf-8?B?dm1FWE5YYjAyQkhqYVdMOUlYQVoxZjRxbWNwY3ZCb0RvdUNwc1VjYnJuSVlS?=
 =?utf-8?B?UDI4U3FZM3hRTmppb21YSE1HZVFpcUZTTmVTcithRVhnTEJHUmQvZ3NoNjRp?=
 =?utf-8?B?NldNVkQ3U3IvdGl1NlU4a0U5aTFCS3JtR01yZzZOa1EzbDJiKzJNYlhwTTJz?=
 =?utf-8?B?dkFDQ0dyT2NiRjRWc1RDS1JDeFNEeU9jVnBmbXd2elRkeEx2dFpMZmplYzJo?=
 =?utf-8?B?dFc2UmlGaWN2cWJSRzBnSGJSUkdGV1dwdE9yOGVoaERJUnNXRVQ5ck44a2U2?=
 =?utf-8?B?SGM5K3dVblZieW44TlR5cGp5MjE5cksreWFZb3JteVNidlhLRi85Y0lpZzlW?=
 =?utf-8?B?TmNUcmJGbGRSYVFQSTloa0lFNVQxRWZqQ1VTcm1GY0IwdGljNHM3aGM1d2hB?=
 =?utf-8?B?U3NyaUJ0SWFFcVhST01OY1BiRmNWVEROK1IranBCaTVHSCtoaFVNMm1PTThQ?=
 =?utf-8?B?eFVVT0JtcGU3QitjMXJ4eEVZMkUyeHR2bUlaYkNHbjMwYm1kY2RGLzA4Uk5C?=
 =?utf-8?B?S252YlhnbUhIaHB0d2NjVGV1UFFmcFBMMWl2QU5vMFNrdUk2NmhzaUxPMHcr?=
 =?utf-8?B?VFkzN0pMQmRVK1g4ZmxWa2JhZXVlYVc0Z21ENVVVVTJ5OVA2b0N2SFh0SzBL?=
 =?utf-8?B?L0JLa1FsYm55UDFvdWVmajlWbi9pdTd1V3pMY2VhMFFiSmVxZ1dJcjJTakk1?=
 =?utf-8?B?ck5IdTR4RlFEd1dGb01oQUtZbFFiNHdiU0grdUR5NmVReXVsdHBoM05hQlJx?=
 =?utf-8?B?ZkdGNnZiUldVT3MvZVd3L2x0MUhMTUxKKzdBMjl0cTUrTUhUbjI1TklaV04z?=
 =?utf-8?B?YS9zc0ZSekVGYk12Qmtka2gxWkxySElGYkpoREVDdCtNZlYrRTE5cG0xZHFl?=
 =?utf-8?B?d1F4OHEzZ3RQQVZxNHY3Z1YrSUFmZ0hmbGl4cEJsU2JtSThQNGluUFpteDFj?=
 =?utf-8?B?UW5QZlMvQlJiRkRwZkF1OFZiRFd3elVSanptVmxPRGFWc1B4Tkp6WWFSbHJS?=
 =?utf-8?B?QWMzcG1saU01ZDlQWXpZN1dDSFFURWdvYUM2SWoxYmRuMURtR1A0S2hDR0xm?=
 =?utf-8?B?ZFluZzZDUzExRjNVdDNrbkZIVHpZeUtyZGdIOG5wYldETk5xa2g0c2M5MlZa?=
 =?utf-8?B?bGpqcFZNS0toWjdHVnpvMHhzN1pPc2RET1hCU3dnV04zajN6eXduNWFCdUhp?=
 =?utf-8?B?d0dXYkZ4ZmxvaDkyU2RPWFlOQUVQRVl5YTZhWnZtNndNcjI0SmVQY2twZnVQ?=
 =?utf-8?B?NDNaVndpUUhubUdwVWEybGlOelNZcEJ6dkZzOERkSHk5Z2c3cjA1Wk13NXNi?=
 =?utf-8?B?ZTBScTRzNkM2d1A3QTMvcUc1NXI3a3BxVDY1TWd1YTdEaytqVEszWHVCd0to?=
 =?utf-8?B?ejdHdllyWXpHSDM1MXAvZFFYRTdzcnBET29QQ1o2c3dtSmFMMjhRNWRIUDZs?=
 =?utf-8?Q?VRtWTz4Sgev/OkhxCqo82Vr7Yd+k2skMZA2Bch0?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea553fe-e996-43e5-4341-08d98da1ed6b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:01:26.2726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaLkQbao7Zor+dhD8ZhHD2+CLFLRJBlYaOuz533dX8nGADHQ0rkn086YpEB7zVkdO/uZwoj35Lh9PBPoD3SYuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6762
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/21 12:44 PM, Rob Herring wrote:
> On Tue, Oct 12, 2021 at 11:18 AM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>> Hi Rob,
>>
>> On 10/12/21 9:16 AM, Rob Herring wrote:
>> > On Tue, Oct 05, 2021 at 10:39:36AM +0100, Russell King (Oracle) wrote:
>> >> On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
>> >> > Add a property for associating PCS devices with ethernet controllers.
>> >> > Because PCS has no generic analogue like PHY, I have left off the
>> >> > -handle suffix.
>> >>
>> >> For PHYs, we used to have phy and phy-device as property names, but the
>> >> modern name is "phy-handle". I think we should do the same here, so I
>> >> would suggest using "pcs-handle".
>> >
>> > On 1G and up ethernet, we have 2 PHYs. There's the external (typically)
>> > ethernet PHY which is what the above properties are for. Then there's
>> > the on-chip serdes PHY similar to SATA, PCIe, etc. which includes the
>> > PCS part. For this part, we should use the generic PHY binding. I think
>> > we already have bindings doing that.
>>
>> In the 802.3 models, there are several components which convert between
>> the MII (from the MAC) and the MDI (the physical protocol on the wire).
>> These are the Physical Coding Sublayer (PCS), Physical Medium Attachment
>> (PMA) sublayer, and Physical Medium Dependent (PMD) sublayer. The PMD
>> converts between the physical layer signaling and the on-chip (or
>> on-board) signalling. The PMA performs clock recovery and converts the
>> serial data from the PMD into parallel data for the PCS. The PCS handles
>> autonegotiation, CSMA/CD, and conversion to the apripriate MII for
>> communicating with the MAC.
>>
>> In the above model, generic serdes devices generally correspond to the
>> PMA/PMD sublayers. The PCS is generally a separate device, both
>> on the hardware and software level. It provides an ethernet-specific
>> layer on top of the more generic underlying encoding. For this reason,
>> the PCS should be modeled as its own device, which may then contain a
>> reference to the appropriate serdes.
>
> On the h/w I've worked on, PCS was an additional block instantiated
> within the PHY, so it looked like one block to s/w. But that's been
> almost 10 years ago now.

Well, perhaps the line is not as clear as I made it seem above. The
PCS/PMA/PMD separation is mostly a logical one, so different platforms
divide up the work differently. In addition, the naming may not align
with ethernet's idea of what a PCS or PMA is. For example, on the
ZynqMP, the serdes (GTH) contains its own PCS and PMD (as shown on the
datasheet). However, these blocks both correspond to the PMA layer from
ethernet's POV. The ethernet PCS is a block controlled via registers
within the MAC's address space.

> If you do have 2 h/w blocks, one option is doing something like this:
>
> phys = <&pcs_phy>, <&sgmii_phy>;

Generally, PCSs don't export the same interface as PHYs (see e.g.
drivers/net/pcs and include/linux/phylink.h). IMO it would be an abuse
of the phys property to use it for a PCS as well.

> I'm okay with 'pcs-handle', but just want to make sure we're not using
> it where 'phys' would work.
>
>> The above model describes physical layers such as 1000BASE-X or
>> 10GBASE-X where the PCS/PMA/PMD is the last layer before the physical
>> medium. In that case, the PCS could be modeled as a traditional PHY.
>> However, when using (e.g.) SGMII, it is common for the "MDI" to be
>> SGMII, and for another PHY to convert to 1000BASE-T. To model this
>> correctly, the PCS/PMA/PMD layer must be considered independently from
>> the PHY which will ultimately convert the MII to the MDI.
>
