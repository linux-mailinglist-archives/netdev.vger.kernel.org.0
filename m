Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB90F2BFC73
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 23:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgKVWgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 17:36:38 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:55772 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbgKVWgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 17:36:38 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2058.outbound.protection.outlook.com [104.47.36.58]) by mx1.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 22 Nov 2020 22:36:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3l05dd0cVJ6gu/Q40zEqFrXxH/UV3zNqvZgqBILKirMQ2VpY5p/3XerNUPmK2bvUqTsj8lA5EvNlo8UODTsZhJhEWpwwo/9QlhSLL3Hf7Z5FXoCNFA9k1uS9DfJgvGMc1zXO4i0g3eDxCSuSa20qndG3/UWZtqPYQMTNxQSUiA6P97dRf4O/ukrU0JCKetVnbWRRzhdRl4JVxIa3gC+0HByEHCbvFYrAlyRhoFKOpLntMpmqedYWGpVPnu4Fyk/A3eydWlZRCYs6vkm+utcsKwjf53Vs8z9vR/AHnUCTu4hbt6Ro1BtasLQVqVmUS5aWauBdPk6NysJxIPvoKYewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HuZzkyQWbD8Itj764pyBJb2Ag/2iMpBu/rWrbFAwGk=;
 b=AvE6F5sielj+y6LcbH8Hp/IIukiOoajZA4CM4wc8dz9t/xjuB/NFmgBbV9NghTeRLpi849LPCxLbuM6t6hjGCEoDu9mzD0R0+njkqY9W2v09XVKur5yR8SQWt/2AzjOAgygqBOUY9lITQj6yfM7/BTWMHj1NHSaJZqApaWXABoRQ58Fz8DNZsUSeEQBuLeEo4CLmR0js8V7B5gb68V6Bc8k+U1GOyRhkSUWvbjRmqbh59Rhd52Vq0n8V3vMCWni11vitR5l3tNlksbEQQ5QmDWKmhJHw8vwrfK7xbsDzm2FvilemDhPHhUOX6shDyUMG0NKCK5nVMpvH2zIx6qGIhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HuZzkyQWbD8Itj764pyBJb2Ag/2iMpBu/rWrbFAwGk=;
 b=B2jCldRCZWWIEZAaX+Py/4ipoVtvacKCgNkNkGlFZBlUPo8YFoCEItx8lJUysRWdI75+YnAuod8F+DPC0ExvS5VzSx7bMzTy2oTR63yNSmfNH43FQUqThfGucOnbnEUXzsS9bGG0zQIRLwKr/tDKkXMAN/O8ktHmTxW/ZAwS264=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2165.namprd10.prod.outlook.com
 (2603:10b6:910:42::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Sun, 22 Nov
 2020 22:36:22 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Sun, 22 Nov 2020
 22:36:22 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v4] aquantia: Remove the build_skb path
Thread-Index: AQHWvs8ZM2n6oge2KEC89hbATIw5VanTGxgAgAAAYACAAaSqIA==
Date:   Sun, 22 Nov 2020 22:36:22 +0000
Message-ID: <CY4PR1001MB2311E9770EF466FB922CBB27E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
        <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>,<20201121132324.72d79e94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121132324.72d79e94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f13bdaae-741e-4df1-85b7-08d88f3709ec
x-ms-traffictypediagnostic: CY4PR1001MB2165:
x-microsoft-antispam-prvs: <CY4PR1001MB2165A67B70B028CF6F7AB40AE8FD0@CY4PR1001MB2165.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZShFP0oz9mLdaNN6CXdJq9rkKJKPYsz6SjdHAuDtb8llAbHFWRc6qvWYqAZZymZ1daO2D+A0p/xzAU39NHfhENsHwfXojCQ8dVDiUutR8sExnGOH2LyK/C3xj8elu/I1YVzLWVPkzygKl/zsMrW18BsqoqGzkMeO2BvKn4vQEgqbnXNDHyMdW4dwbh3Xe33JL3s7L6gAm8asW2C06F97v/hiCiPV859kp54mIAcL997pHM4O9Rl4hQqOwxXjkjOaj996ONBZXRKO6savg+5LiaX6hwjLhqMF33TDhN8pzxlwWPFIEt4WwHQGoMJSpsce7vQo7fr1SJaKSj3ELL+sNbpezbHqa4EKoPOWDVT/khZmOIVDLj5Khp3jc/cQuF8TxQhjJYBirSoh1LdmmPAnng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39840400004)(396003)(136003)(8676002)(186003)(55016002)(7696005)(316002)(76116006)(6916009)(26005)(54906003)(9686003)(71200400001)(5660300002)(66946007)(2906002)(4326008)(66476007)(478600001)(86362001)(91956017)(33656002)(8936002)(66446008)(6506007)(66556008)(52536014)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ff7Y7Y/zNOsMAODhwHPH5upWW1DHJyqA554eekKKW9JJrxrBW8oHam0eI/4ciYMQemJSBSzUyz97D3rfU3bA6F5cMV6N3C5B6x5uG+qCtzyO2SpTIo5lwN4u8zNdV4Wxo3jr+nE0VydtCx4+BfmudEt29FpzcsdwRL7xhTaTGGgnQ3PNz7uZXzW884z2jlQgvNfia1Q8zWVOwtyO9M8OExGdOQOb2X+7/Sp44pBD+6oH5GhOzdd+LWBjK2s6I5jutQ3jR9VdvRtkOSgsTZCEh9BNckkhSWscjKDPxAVCqzycq2oghdgrUWmu2dqMKBj0ixyvQWDel7/Mucpz9C8h0cin+h7Efz5pVC5TYQlx/WvP/LLYITB7Ds5JIH51WvvQU9FYcJSKJUHVi65FABS7pCZZeCnp+6ZQcEv8bP+ZUpwZsCz9p7GOovIm5dWT6u6B/4D2g19eEFCYFgpb66EAP+KPo/Vb7uEiX6P35Y/lMc5e/yd0uUV/NhgIlpkTwAsZeirf3ekqXXfESJ1O6n7wy8ec0ulTR/PcUhzgsYZKDYfYHC1C25GU8+6q9adZNo+q/YxtFi9/tuJybmjJXikw33BtLBF3LNBvRg2l7QaCSFAgkDK2KhrEWFcu2Ae4h8Ij9zDJ9IPQL1V6IfXX5kK/X2Dabte+HFV+/TGYHAI7KorcK13EyD7cLOdIa2i8NPaO9miUMNVWg+d+WWClSqfwnEQ39ULg7q6TVOiJ1bkwJS0JpriusnP5QhNm2svjCsiIv0YEZh/fZvbQb3x6nZk+zSoU4CcOTSsIKXkKPSV7xc08i7YMPUgCKUHhhbgGa3CDKKAvzJQt5teLowTroPUWh8IrAvUKYATSMpUeVdUTf/NJyMJCw7DCqztoc6AZ3HH5Yjf6dP+Xlo390TwMqr3zgw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13bdaae-741e-4df1-85b7-08d88f3709ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2020 22:36:22.3825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APs7fRv+2ObVAluCI5LPhvxbSfwVT1w3wEW+XLNq4y3NogMZXlMfTuqv7rj9gfqpF6UQ2kONX1bMe6oBOkbbhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2165
X-BESS-ID: 1606084586-893000-807-142732-1
X-BESS-VER: 2019.3_20201120.2333
X-BESS-Apparent-Source-IP: 104.47.36.58
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228373 [from 
        cloudscan21-99.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (Next time please include in the subject the tree that you're targetting=
=0A=
> the patch)=0A=
=0A=
I guess you mean like [PATCH master v5] ? Should I be targeting something o=
ther than the master branch on the main git repo? (https://github.com/torva=
lds/linux.git)=0A=
=0A=
> please add a From: line at the beginning of the mail which matches=0A=
> the signoff (or use git-send-email, it'll get it right).=0A=
=0A=
Sure.=0A=
=0A=
> Ah, one more thing, this is the correct fixes tag, right?=0A=
> Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")=0A=
> Please add it right before the signoff line.=0A=
=0A=
I didn't quite understand this header... but yeah, I guess that's the commi=
t that adds the fast path I am removing.=0A=
=0A=
> > Align continuations of the lines under '(' like:=0A=
> =0A=
> I am only changing the leading indent. Am I still expected to satisfy the=
 patch checker?=0A=
> =0A=
> The current patch is very clear about what is happening if you do a diff =
-w but if I start=0A=
> changing other things to satisfy the checker, that goes away.=0A=
=0A=
Some of the patch checker complaints are only leading whitespace (obviously=
 not a problem for diff -w), but 2 of them involve actual changes (changing=
 , to ; and moving the first argument from the line below to the line above=
).=0A=
=0A=
Lincoln=0A=
