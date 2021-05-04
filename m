Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9219B3732B9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 01:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhEDX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 19:27:19 -0400
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:53774 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231226AbhEDX1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 19:27:18 -0400
Received: from pps.filterd (m0220294.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144NQ2HY023608;
        Tue, 4 May 2021 18:26:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps1;
 bh=qfFV0mBBaebNMiSdG6/zxd/ozUwo+Yf0EEBddPBfpWc=;
 b=hPKJMSnUwBT7FMG3dFfmRtDWBSmfqyKKSUXuNBrnj1N5Swf9aWWM7d6HqPd0QWiYta0F
 5tspmMbdtvkid6uBLN9CRITWoel4nmCgV6FhLeq8SjmG4y58ouI32ldSBst3RnAa8N6f
 VXRZUvCvqXuBQxsQ1G4dkI4La0Ms7FCH0mTAmO2UvEifQ36N4GX2wWrgUU/MwQWplOLc
 uXWdErY32Oq6jMcqW722MW6tClfURzR7LXD/uJyt48wvaTCyReaPvUxXncWdz2zwv4+5
 CAvyudZiM6ZuDggSadf6E4tDRDgi/WfsWaDYr0Q8OgvU9CHDvDIbX+AN3tJtSCwj14jS 7Q== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by mx0a-000eb902.pphosted.com with ESMTP id 38beat83gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 18:26:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWeB5vTxuw3IF6zXQSJD+acE0djkkFYE4gVP3Ivry8XmJljpgROg5NnAJBI4ZanrflKTdA7qIZWd+F6fUJVXVPlMEY+P168QnRMqXFVFSWdVUdU6rqRUnaTbMiMzUJu3mmHecLXlIMcrnc3JhuGTu/hhBB7qST8YDcJYgtSWZ2yIz9TcVtGQRGEtW/Ok/zBDzghTFlruC6sSBAdrb87Trfc/RPJBFaP562r/4oCS0ecQuxmmfwRwxvUVb0iZT/38yChbRA0PNyapR2UHVDSbPZbF6VdTrE5WUbtcSsQerLt+djVrgqlV5Nx7/T8d9Y97OTHzGN+PXqr3w76eLY7AjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfFV0mBBaebNMiSdG6/zxd/ozUwo+Yf0EEBddPBfpWc=;
 b=EqxBE9At5etmdOJ2OF8sVzrTcc8Q/ueVO8hVL/QDLzH4lJ1sol/O95p8RI+5KOGK1UVdCTPdopZ9ZS5EbTT08+Nu5NRQXtOxD+rP3U7ptAtLNDykYv7quSZ5DLSgFlt9oHBFH2A0uO4zQsI4Tu7uFwdgyzzChhwNq0YFMcS5mm1s0KiCUHR4zyqhfpGm1e2hq18KEjzuCfwkBvPCEGFjswB2SBQ329ewfn4AJ9Nl0gweKVF5Qa2x9HUdPqxgMJOme4ylgtoIin12A+dHQWO10ZXHBL2AUQ50YNtenk2F9r1vo9nQK99HSbtspX2vsp2ed3xDiDe0bPtWPS3Xk/omjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=waldekranz.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfFV0mBBaebNMiSdG6/zxd/ozUwo+Yf0EEBddPBfpWc=;
 b=JVUkMwiRHpmv+LpYmfeiUDH85wSzAlNwlE997nvGsi2Aq0o/BoN88Uv4AN40gIXAsOwA+c047h8JtNyHRBdk9D5coz4dSbthedOUBiEG/OOvgwnR4f02UB7c7h+ILjC2TVE8NujPELUmh/Cz6+NM0hQ+swE/BlZgSjyLalYgreoJZ/df5PQOinS5TQ1q69a8tb/Xhmkgoouwrray2oi3ZtCt2sYvO8x24OxnKS/w63k0z9OGAarP7nMDgKHiE7dIYewOUfdSefjsg9s8eiAxE7H5jvlIFNStJT+43IFmrxF4KeJl6Ez1u8baV9TfruqlsFWBfE4LZe3hu2gr2U+vQg==
Received: from CO1PR15CA0112.namprd15.prod.outlook.com (2603:10b6:101:21::32)
 by DM6PR04MB6590.namprd04.prod.outlook.com (2603:10b6:5:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.42; Tue, 4 May
 2021 23:26:11 +0000
Received: from MW2NAM10FT047.eop-nam10.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::15) by CO1PR15CA0112.outlook.office365.com
 (2603:10b6:101:21::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Tue, 4 May 2021 23:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT047.mail.protection.outlook.com (10.13.155.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 23:26:10 +0000
Received: from OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 18:26:03 -0500
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 18:26:09 -0500
Received: from OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c]) by
 OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c%23]) with mapi id
 15.01.2242.008; Tue, 4 May 2021 18:26:09 -0500
From:   "Huang, Joseph" <Joseph.Huang@garmin.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
Thread-Topic: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
Thread-Index: AQHXQRKRJez3iJGzm0eCT/EpouXvN6rUE08A//+0kwSAAHPJgP//uwHO
Date:   Tue, 4 May 2021 23:26:09 +0000
Message-ID: <82693dbedd524f94b5a6223f0287525c@garmin.com>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>
 <6fd5711c-8d53-d72b-995d-1caf77047ecf@nvidia.com>
 <685c25c2423c451480c0ad2cf78877be@garmin.com>,<87v97ym8tc.fsf@waldekranz.com>
In-Reply-To: <87v97ym8tc.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8092d81b-cac4-4b73-aedf-08d90f54008c
X-MS-TrafficTypeDiagnostic: DM6PR04MB6590:
X-Microsoft-Antispam-PRVS: <DM6PR04MB6590CEBA319DE693AC6777EEFB5A9@DM6PR04MB6590.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5oy3cEDbmb0z7WYY9/ZPqMdEK+Cr1nMu+KwVgZCR8JLtddbKcdeu4UOSG8ZLh5Og5wrUh2I8d9A2P34gnN2IQ065uqZNbz74mnNqtRFI0MgKyakP03bHgnkvsd/FaKalxGx6UvKShnpqJscK03EtTqVRkH/gbgzzchbFSyBsGqajakc4IJD6kagBC5Ek9gxPcNu1sKVbdSjhdgjJvfV2LV86qYZcbiogcZwlxvoJNYSO51e+2LTsf+XbJvePOZyjEEV5YbgUMLRwGNLP9PXpHaDUT4pK1RORH3fXwqstuAmPU8SA5PALrzmJa9eZa3VBHzbvNMKaDeWoxAI93GYPX3zeeEO5hXPH4LjyQx2YCOu/0XGUxpNrP8vh0jSmVU9P8iSD8QMmwJpEabfj2EgiOxV6u2AtHMxxAHdR7hEceB4KtVQzWundJ0dYgLzdyTKjRIORYJj5bKuzECRHzjoU0k3WmUKyxCvUdZ1BsPN2+6bDSl7DmuYpjapBvEwVv2vVItE8OTc+mYDKZTFSKxswYzM6utrDRxAERvC0/30asTPi7WjBFIRrJby5aXurTpaq6TRW2wRZB+iRomzGSt2BP6iORqtQfcQxnmg66Nmrdl5z0B/B+dhS7Olv1P06PX7I5qhZ3Kk36Wng6CT71JN4Tv/pM73wwsGSHheLbutBZec=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(346002)(136003)(39850400004)(376002)(396003)(46966006)(36840700001)(26005)(36756003)(7636003)(316002)(8676002)(8936002)(70206006)(70586007)(478600001)(2616005)(426003)(86362001)(186003)(66574015)(108616005)(24736004)(36860700001)(83380400001)(5660300002)(110136005)(356005)(2906002)(47076005)(82310400003)(336012)(7696005)(82740400003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 23:26:10.9125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8092d81b-cac4-4b73-aedf-08d90f54008c
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT047.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6590
X-Proofpoint-ORIG-GUID: 9q0Rh1avxEsB4hhIEK16WU05ftbYCiK1
X-Proofpoint-GUID: 9q0Rh1avxEsB4hhIEK16WU05ftbYCiK1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_15:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040160
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If I may make a suggestion: I also work with mv88e6xxx systems, and we
> have the same issues with known multicast not being flooded to router
> ports. Knowing that chipset, I see what you are trying to do.
>=20
> But other chips may work differently. Imagine for example a switch where
> there is a separate vector of router ports that the hardware can OR in af=
ter
> looking up the group in the ATU. This implementation would render the
> performance gains possible on that device useless. As another example, yo=
u
> could imagine a device where an ATU operation exists that sets a bit in t=
he
> vector of every group in a particular database; instead of having to upda=
te
> each entry individually.
>=20
> I think we (mv88e6xxx) will have to accept that we need to add the proper
> scaffolding to manage this on the driver side. That way the bridge can st=
ay
> generic. The bridge could just provide some MDB iterator to save us from
> having to cache all the configured groups.
>=20
> So basically:
>=20
> - In mv88e6xxx, maintain a per-switch vector of router ports.
>=20
> - When a ports router state is toggled:
>   1. Update the vector.
>   2. Ask the bridge to iterate through all applicable groups and update
>      the corresponding ATU entries.
>=20
> - When a new MDB entry is updated, make sure to also OR in the current
>   vector of router ports in the DPV of the ATU entry.
>=20
>=20
> I would be happy to help out with testing of this!

Thanks for the suggestion/offer!

What patch 0002 does is that:

- When an mrouter port is added/deleted, it iterates over the list of mdb's
  to add/delete that port to/from the group in the hardware (I think this i=
s
  what your bullet #2 does as well, except that one is done in the bridge,
  and the other is done in the driver)

- When a group is added/deleted, it iterates over the list of mrouter ports
  to add/delete the switchdev programming

I think what Nik is objecting to is that with this approach, there's now
a for-loop in the call paths (thus it "increases the complexity with 1 orde=
r
of magnitude), however I can't think of a way to avoid the looping (whether
done inside the bridge or in the driver) but still achieve the same result
(for Marvell at least).

I suspect that other SOHO switches might have this problem as well (Broadco=
m
comes to mind).

Thanks,
Joseph=
