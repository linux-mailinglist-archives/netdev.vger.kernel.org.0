Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF96464026F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiLBIpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiLBIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:45:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A953A9703E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669970748; x=1701506748;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=afewgxdPrwBUxTaGT9v7lg5S5r79VlgKD0d6B1Ebo4s=;
  b=bVouChd9r4iAdME/0zpMIZi7kuhZSRmW4q8m8foN4hcTUVqNmtRGQdD5
   ktuZvYn4yhSMJnQ/QSpCxMdwVa8R5fGSLS/9XezgI13xox1+ZhuZbmbhk
   Wuh0jO0ysWZi6OXFhLIswBxyYdHHmwj9WTE5bCCdKQCslPWKWbMzxK4Xd
   nV2flSlrmjefFCzCe0I9dU7kCNoBk+JbFjyZWRJQ6OKt7Rxw9BGjfuIZg
   ByaHaPwGfuRSiaC3hzNGi5GtOsyfxV47WEkDgz99kKxXG9CqDsLUZKW5r
   srCx11ZcpYX83G4F+GVzTNIK/T2Zzta43cprs+1yem7UT1DwJUrqk69xZ
   w==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="202318914"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 01:45:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 01:45:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 01:45:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw6/aldRupxz574enqeX08+W2MRV+nMO7y6g9mAi06uQZNQ+m5/e4RfqR553dBrkfmFa/J2ZAkQXiDGIdRodiu8KJ66Xfu5m5Fs7bdYdMsHBsZ3GCHadNi/hK80FkKfrDrU8sF4x7X/RjeTf9xIuIBFJsW0SxkY9n8fmE4d+IWCFPUSQ04IJVyXDypXB3ofuiAGOiMb9+ZZXPg+Rzwt1kIoTF11gQgI8TvNe3wBrU+ZbwRVwn+1re/UQVyLejk2dZeU2sxWBCHzmUfEldXG7KDU3qgjUuDX9Hl+Z+oN2fi18aJaT9GzC1hALhswkeGWAwqEYMrx+ZSkmmroJpkdVjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I05XFXPNKYQVRKIARjQfZrvcXYnCOeMXhyibDltwdFY=;
 b=OcriYiOpgNk/qQ36UnGU5kg4+G9azDihmBBHNhdst+P+sRA9rpZgSeMNetEK+xeknjVwVkk+UrngVpin88Xez8pHhLz+XBgp8huZckZ67KGYXzvCaorqkoc1oRDZru9yNyHnbHQFrKzcfnswu69YPgQ2YVr2ZySYLqReBh3SLwhNKOwDkg16dlLX4pQsQ7DMZLe+hnh2iN8hk68pJhVi4vk1ia7Mcrt0yGZHVSlUAAMcktxO8uLq8q5hRXJh6PAccg9sHDuVriDII+D4Y/EVOigKcysCfkcu03c9Mh30YzE/pwOxwi3VouveSlJZ+OlZYVydfBpPkuR2Gg4LsaD6Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I05XFXPNKYQVRKIARjQfZrvcXYnCOeMXhyibDltwdFY=;
 b=Kn9hedlBr0PZKhJsmmRtHNvVRSQrRISZSpMBIPmpojdN588bx4FO5wJ+II52NCxdiAB4cvKIpGrFIJB55uHrILMK33FZ/B3ug6IptKe4afVIFtNODTDbxt1ILPNMp8IbEEUCCziJ+UfRtuVx/ZoPoO64A6bI25cRe/x9kBHolv4=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DS0PR11MB7312.namprd11.prod.outlook.com (2603:10b6:8:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 08:45:45 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%4]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 08:45:45 +0000
From:   <Daniel.Machon@microchip.com>
To:     <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Topic: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Index: AQHZAyTEgaoiyw1Zp0qGRxNbVYyYpK5YmiqAgAG3n4A=
Date:   Fri, 2 Dec 2022 08:45:45 +0000
Message-ID: <Y4m925XVWIeeunLX@DEN-LT-70577>
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-2-daniel.machon@microchip.com>
 <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
In-Reply-To: <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DS0PR11MB7312:EE_
x-ms-office365-filtering-correlation-id: 77ebbf75-6838-4fcf-ae1f-08dad4419a7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W49yXYqXcdwX/ddUp5VFcmoZm2VXiZpeA24ILHjSDuNND80PjM7C1PXBeyHSoocShWfOnZdEjF67taiNIiAt230LfIBlHQ/pvkHSe79b9xdWSq70HV6hI9dacIt8VkkZLrDaMhTkD1misNx4wwcd5BRhLLYpXZfDINoav3+VFIJVZ++DH7TT9IO3Mlu83PhxEDb4C94+AV7bDULspauU2xj8M6jaqdMVoBe9aot9TDSVm1AUvyiscVGJLeDXj9qHxfvjcfrPSLvne12HfmPfy/A6g/47SHzYSKZBsB+rxF9/w+A261qMl9wUgT9EPLsKCGMNk4fNWVBXE8R/QbLmIqQOBWLfc3eEtjjOEFkXsm59ZZ1BSn3Fh9LEfd7yxHpWzGWWfvI5UaZo8juvbeu3mtjuau7ekXlBwsHF1q5CgAJRIyQet+4TRBwXRXo47k09mpXaGAs3Z7fwwwvpBKTFUglF7BMLBrH1Y1+gELfsPfR77J+PBQr8efKOFe/9Q+3BKxQT+MFmHNcNXy8YLtxrwnwjvyqm7BHnP0pldUFKtFSyeXJsB2ARQURcdglvyV0Mr0zcob7citGVDQIEOO8DQK4OsAp+qBm4JAK4zuKraBbqDik4O2xaqoJH92dJy2XrgobENpxAqNTkwDprdu4888v7pxjaJ58iZAE1Lj08bpC3Z0M49iERndX/qM9w7k918T+5EZAwr/MPIyDO4vVhyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(54906003)(122000001)(6486002)(6916009)(316002)(38070700005)(86362001)(6506007)(38100700002)(107886003)(83380400001)(186003)(6512007)(26005)(9686003)(2906002)(53546011)(4744005)(33716001)(8936002)(5660300002)(71200400001)(41300700001)(64756008)(66476007)(66556008)(478600001)(66446008)(76116006)(4326008)(91956017)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LfYFqfM8lKMs9F3GXnxaAoDSnDUqd0VZWQ54v+dmVZ42/kxsiGbpJe2KgwEo?=
 =?us-ascii?Q?8BfRS0vCCoe6YCtSzdoorZtebn7pu+YJlNdojEwItODIetq6uBuq+soQ+jDE?=
 =?us-ascii?Q?eMArbYLdV7JbviX1DOwqde+m/+lgXrMZ6Bqt2BkxHX8kcY1OmOyuzQajaedF?=
 =?us-ascii?Q?ESFlvpSYxH/v2WXBTJl2TklWXbRkAyi8td/yIsRzgfO9iQ8g1yaBnkXzZWii?=
 =?us-ascii?Q?rmgwJmAUJYDjKgvv0Xzg9B9WldH80uvbAyn+ZH3Hb1oa2ZScmuYjiaIeDyoE?=
 =?us-ascii?Q?lzP+KsTKBx0b2S9CpPl+UiZ4qHA3DVeC9d0nIS8/LWDw+S+AICrbQjGnuSay?=
 =?us-ascii?Q?MSqIP9CRxWe3NMbF5SP0xEk+mOP66Mtq73XbxwI3Hs9/5BDnDwUArM8cN2N2?=
 =?us-ascii?Q?k/MVjlaLk9KB4QpHJ6WGprJtPvtUQCXXuY511sPiTxJnKurnVO6X2oVHaKeC?=
 =?us-ascii?Q?Fm6vRU0XJ6PNVBhtmMSCnzrsjjHyT6WrJ8XsaBmqIMmqBz77MlbqMgaTy0nJ?=
 =?us-ascii?Q?meU28AvhJ6ltAMzRXVL2CROE8QEOvv9qIjrqy7dSPo6DGcTZoo7YO+b1mcn1?=
 =?us-ascii?Q?Aw0bv151dm7GgeHugfHre78uQOayR02I58P/sRh93YgJLhVFb7qLjECR9xMt?=
 =?us-ascii?Q?sesFRztTf+nF52dSN1ZkWB+A3+po6+pp4BOIkbvbz7sZ//WiFLRA7+TEHQu5?=
 =?us-ascii?Q?1AdlK3YnB7/3NMffbFlZfbBUkpEh09QyD8jPDj0/wgK6uzFsbvTLUrsaMkZ3?=
 =?us-ascii?Q?EbABsMUTuJfdmfyXAwiqVn99goeeTQwyaCTWNTo9xAO0zLn1ZWHB7Z+Ng+kl?=
 =?us-ascii?Q?RfDIrYfSXwI4x31IyoSZzq1Rpzqog6qDjTFLUO41teGAU+hTEdch/5gxmEaG?=
 =?us-ascii?Q?yunGVjVW5uoUc+TiNGaCqIdfzzDGPSz/4ePUP+m6spz2zsmzZTy0Fns5v1vv?=
 =?us-ascii?Q?iDrcQdUxTmoP3xoMrW97Zs2WN8anzxqg4CPlKqCSPWduokQDa4tWa3h6JmiR?=
 =?us-ascii?Q?xFNxZVk43NrCNpNHF+zhkaj98KCKbGfvhElkk0pHzZJqrHB8TEMuSNBa0D6b?=
 =?us-ascii?Q?qTk7rOcpdWcG4HI6hKgQBkmB1R7YgH/B6HcXlWqAjzKpCXzJ1oVUdqQnvVC4?=
 =?us-ascii?Q?NXBjWelZnR5UsKhb0G4/PepBXF5bkxKnWehBa1Ny1w0r6UbQOommjH02Mw3p?=
 =?us-ascii?Q?4rijcx8zJ6gf+iZ9Cdm2bTzworalXugdB14SAgkUCdPWUm74mMo05Oeg7P95?=
 =?us-ascii?Q?bOYJcavfSfgubzCqQwG5sYvsJnoxpll4S1QrpuBlZ5XX7H6JNOcXK0eLPBPF?=
 =?us-ascii?Q?YgJR7DigaPwJTcNHuSwXReqMlpGnk2wfnJx+mmEm2S66Je9C7/IOU4WYLEJS?=
 =?us-ascii?Q?T0Ofy5qmTK4bEKbiYXuCR/VKRIXoyM5VcRsI9I/vz3b+uA37VbIYambMUCKT?=
 =?us-ascii?Q?0M6ky4ehlipwpxhmBhubHrojzaewFPfb8UA+cJtQghDIdpwmx7isxR9oq1ri?=
 =?us-ascii?Q?+JOPBv6bFJA1VHIzRQVmXU5143EDxwYbUJ7ySXExgv0OKHBAb1I8viW1LWdo?=
 =?us-ascii?Q?8lOpBU8ZApuu+6wwvwEMlmcUx4/tpuAna9qGoEPskhcvtaD1F5y9uAgu3vNQ?=
 =?us-ascii?Q?gptlWV2j2KDvp/G9Yy/tJzI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFE9B13E3AB9BA43B09A00B552C1D101@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ebbf75-6838-4fcf-ae1f-08dad4419a7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 08:45:45.5677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wPjiDB3j0+qCusTtfjY1Qig0h1ZX68dfPPw2mC4TvnN/IClJSj7rf/D66cgGThPBWt4GCFFwwkmkEAZ3h+KzKJ/Ag9ZSeqJDyMy82ymXs7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7312
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 11/28/22 5:38 AM, Daniel Machon wrote:
> > @@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
> >       return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> >  }
> >
> > +static int dcb_app_print_key_pcp(__u16 protocol)
> > +{
> > +     /* Print in numerical form, if protocol value is out-of-range */
> > +     if (protocol > 15) {
>=20
> 15 is used in a number of places in this patch. What's the significance
> and can you give it a name that identifies the meaning? i.e., protocol
> is a u16 why the 15 limit? (and update all places accordingly)

Hi David,

As Petr pointed out. The value 15 is the maximum number of PCP+DEI
values (0-7 for DEI=3D0 and 8-15 for DEI=3D1) I will add the suggested
change in a new version.

/Daniel
