Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BAA6403C2
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiLBJvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiLBJvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:51:06 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A849C7265;
        Fri,  2 Dec 2022 01:51:04 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B29nrAw024616;
        Fri, 2 Dec 2022 01:50:49 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k8k5w47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 01:50:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMozk2PNgRMwybl+aItr6VzrSS9ilc5j3ZQlv/pDVe766IbDsrKRaMnD7BJLdgRokYwGqvL1f9G+Esra3BPX0oimgsZlb3vYlMmkqLwUlx3ks5xZzhjU0gIW9Ys0luf3a8jfwlTk9/Xuzi+MP89Chl91Jb+Ss97ZKAdLTMOamp1NHG+bq2Hz/RpGkmQzXZou804qSLSalBEgK0J+O/VqlUJ6PCF8PzZxOGhCARZ9klxnb1QZKGKmnJY/5YPNrOQ8r72+vwtDcgHNPS4h5UyxJG6kxjcLgBsGl4AAq7nmcKf5qjIR3nAdDPyAV0AU4JapaEvIZpIBiAG0maaUjmmKbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YD7qiuxQdUTr1VN89yEAfnlKATJUUoqekA8/9Kb/Kvs=;
 b=cj6TbvmW7AdEjgVln8V1VtKYjv+dLwzuA30N998PSQDS6h3qrs/E2/HYXO+jCv+WsnAIPWaQobF7QUgkI0T88O1gOnM1xTDUyGxF3zNuEmzid11nIUBt4cLcSC/v8kROvMm2JAmHqpfTxfVYc9lR9+1g0gEswkkxQCr+I3E2nThtj8WD8L0Pv/OrJJxbcCYGZ1N7GK0H2ZR1MXmM0QmgmNX0AlejbhTXVbckNVjZX87U5IF8xb3vYToRdBJ5UfbSvazGSl7dAAFgYf0VRDWrsOy7N3UXEW5KDNq2ln4m4B+77rd15El234qU8Ss9DwLw17J8lnAo0TB22iy2p/krXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD7qiuxQdUTr1VN89yEAfnlKATJUUoqekA8/9Kb/Kvs=;
 b=LW/NgXuSCLfNqCFYIVFpQH6ZFxiSItdtytGhaTnk+24Mrib/fEYdkGvET7jYKuNncyAUPnmyWyspeUfTN+Hq/Rdg2G9u/3YzC2yQ1SK8jpu7cFqTuulGjb5akfrKqECAtuXNsqovX35KyQ4chVc/IjqgwssfgzSgb+wq2LADbAI=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by MW4PR18MB5133.namprd18.prod.outlook.com (2603:10b6:303:1b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 09:50:44 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 09:50:44 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "sunil.kovvuri@gmail.com" <sunil.kovvuri@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
CC:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak
 in otx2_probe()
Thread-Topic: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak
 in otx2_probe()
Thread-Index: AQHZANRUZLikb9cSFEyd1JlStS0yCq5QZIkAgAl5CwCAAFBxXoAAIhSAgAAT3eY=
Date:   Fri, 2 Dec 2022 09:50:44 +0000
Message-ID: <DM6PR18MB2602BC59FB6FDEA91F2CE4C0CD179@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
 <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
 <Y4DHHUUbGl5wWGQ+@boxer> <f4bb4aa5-08cc-4a4d-76cf-46bda5c6de59@huawei.com>
 <538c8b9a-7d6c-69f8-9e14-45436446127e@huawei.com>
 <DM6PR18MB26020F45167434B409A32AA7CD179@DM6PR18MB2602.namprd18.prod.outlook.com>
 <97439096-aeab-f24a-1767-b535cf29b49a@huawei.com>
In-Reply-To: <97439096-aeab-f24a-1767-b535cf29b49a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|MW4PR18MB5133:EE_
x-ms-office365-filtering-correlation-id: f833c581-ff78-49c2-1e80-08dad44aae50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agTs4mJlCT3bP9t5oWfI9tr43YEZnijwxJTGAU4XLguGmwplDIJa5SSHRhQx6X9MjnKp4taiW+Ojya2XBji0uyI1t8IUOQL9qA6pBz6aeHfOBUWkHEH+FdbfuLjW/4iEGrPrO0u7Kk30mVf8YKR3LuzjuNLEh2Zfj8QxoWeTXjTrIkH7RtD1iP2DNfomIK0e1VnTB9B7O6yftqTtl8NngXKhCJ7MviWDuMz/PyrGXruh+cGWF9GKKYfoBnkNkc3IiryLt0UlU6G4maW+6vqd/HEzxHT83v69NsQBrOmJGkgRu9aMJVLTgDFJ38ovIigsuOje+V1H9Kh1GDB04dLHW1qYEj14BYrgzk1fimBwof6hONY5sDrYVxzjTUjBiAsRl+GHa/G5A1pKLgXTdetOg3aYmu3/dyy6ubWeIZ0o+74mESKqWUroefzKrldSJvg5vsLAYHnzSiFRoBHUpH6rKF994AIV+tT4CZFboZ2fF+uk1irL7K3fMZ+002aGxDaQNPWsM9kCGOgOZn+k13a2ANufgfT6dTV+tgDgaIY1weLpeFaG1mPNuqXea4M15/ZmEJdetNJZ3yRIQTa9BUF679ZCBB7wpG64KwUBYg6Vp+NeCxLSHjwBXg9xXQKjmSbZXN3vc2enpgCrMY2Fc3SNWPSR8Ew96xmSFZB305nZhqO7OlRfMrg/P761PZzm+g45gQTEj0+VeGGSmO3iLh0MxpokMj3feWWzX1QBawcHZco=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199015)(66946007)(64756008)(66556008)(76116006)(91956017)(33656002)(5660300002)(8936002)(66476007)(66446008)(86362001)(316002)(6636002)(26005)(9686003)(83380400001)(53546011)(7696005)(110136005)(54906003)(186003)(6506007)(122000001)(55016003)(41300700001)(38100700002)(38070700005)(4326008)(8676002)(71200400001)(478600001)(52536014)(2906002)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?QQDRVOwHtB6JoOfB1aq5ypyRT5YiPjWnK7ipwG1c/5lb7hBTfQXh5AzNho?=
 =?iso-8859-1?Q?3VLpZAwWGlVqvIu97Xc15OsfP5ZyA9Qw51DRO6wOGv50/eVxQuBjb8fOGc?=
 =?iso-8859-1?Q?hubqHBuCDGxuiobsdsohIcYvHz5/9xZ7NsN62x/9QxSfGig2vMUGfZGzku?=
 =?iso-8859-1?Q?llSPmf6AUHzpw4ngLGm2UQrcBTIAFLAlSN4qi4qCLcURkF+KoVVLbIWhuU?=
 =?iso-8859-1?Q?om4O1Q4IWkkEWeUkBtzhhLxvdQL6jx20J7wO1JSYhH8lTWEdEn6pbzNyHW?=
 =?iso-8859-1?Q?/RpwIRH+c4BCuUQEnDUUus7PRtJeljDwtmd3+Ildip77x5yUy8cvWQEkxt?=
 =?iso-8859-1?Q?UaIbc7mmaXssvDDgJcyRYx4hkkZ7cCqZemD2HyoL1WoROr5Li38P+cHoQh?=
 =?iso-8859-1?Q?67w7YJNDaG2nj+976Z70E31bAoaPffIgNY37zT8PW6m82DEjzee1t/eufj?=
 =?iso-8859-1?Q?fQO7sABSfAHlYAsyAUvBN8p86MLIIFeqZ8AFO20Kf1K2f2foJx79ecYIQA?=
 =?iso-8859-1?Q?GUTHrRV4t54whP5cDLnDYKZ0iZG2SjlFigtv+1qtSSqEK98eGDR0RlIfbN?=
 =?iso-8859-1?Q?Dt/jkEvOAyPEV1RW+DhyFZu1yCc3eQC3+SJzvDokstg9E9Blthdgk/DVDc?=
 =?iso-8859-1?Q?gCVTZM9zEd4Sv5s0o1ikttBSZtYPMNOX0jklzAQj5wUzgtp+SnD2nlu/SS?=
 =?iso-8859-1?Q?zwZ/hmvF3qnlMB4PI4tsO7T5u+JF73HAIkXnbosdBtnDbvNjgmO19sxMIb?=
 =?iso-8859-1?Q?iqBExoj7vVJvVtfe0yvLh+g5Urqcg/dHDmRTRuckDrBKhYy4G2AxIOLQCe?=
 =?iso-8859-1?Q?p3GwdIvR+wxnaD90rnyQLrzuG0zp9LvcTUS959OpJsFkk6oMaNwtC/W0c4?=
 =?iso-8859-1?Q?8iBTVfBtBQMXty546eKAwZX5QLhCl9AgdQAktiDuQHjaQHUXLYrXv5PuPQ?=
 =?iso-8859-1?Q?84UkEb1FXYznwOb20y9z1oqaNOgzu5CWwN26c+hsfxE89jJxmLUK9XuaD7?=
 =?iso-8859-1?Q?gHZLSsmZxAQQ1vBEv3NvKjPLy7mtVXJekr3Z/b3GmA202sm8myF13yOlmC?=
 =?iso-8859-1?Q?MzJtrru4A/amxJDxXrzhBCvrFPT1V5ILyeu4aS4YehLnpk7F/vMomcVMs7?=
 =?iso-8859-1?Q?M5WM8jNUU08tTmjeDxKHlTmisKGJSH8pGdzV4cWF/Q4Ur1nuZHKzYEitcl?=
 =?iso-8859-1?Q?9ShmMBgPUYW9dMbx5Z9x+qkmKDgGNF3NZCEzYyXUZ9GL8Ilm37YUO/oVrG?=
 =?iso-8859-1?Q?Xtir3f6OwxK5cV/0fEPLSTNtZvYfFF1VlcfuE0WNTpNhKUPkOyeWYnOPeT?=
 =?iso-8859-1?Q?0EU8tYuWbv6ILU73PRcwxaa2o92YRPkWloHmJiSP9baZKm2KrC/OP5ztR9?=
 =?iso-8859-1?Q?W9ZiBpbFzjhBbkhfoN8MignK7nnUSPvsC8jb3ncdCkVM7t9J5HQw87lZdD?=
 =?iso-8859-1?Q?2o7lhWHVRV03fPIgfri2mVx5L/BFL45cjIG2DGtFk+P0AsrfIStqpO+ee7?=
 =?iso-8859-1?Q?5AMV3gAD7H4ukbDPJsNe780ofYqtzYIfm37s8lwu8kmbWFOq8f2BU2zNPa?=
 =?iso-8859-1?Q?hGey5UnD/DabjXD0uc0pCQqddmrlPFBfeImThbckXbLtpiyC5PsMi2mQxP?=
 =?iso-8859-1?Q?bkn1XluB1uSN4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f833c581-ff78-49c2-1e80-08dad44aae50
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 09:50:44.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWSmVeYlFM9KBMhMmnKS09nAmD8AykXYBEEzh5OfaK2umA+lPHxPSrIO5LIrIfVjxtW6YxijwmiTt7E6QoLmlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR18MB5133
X-Proofpoint-GUID: 4sQQdBon4uTcOVKGmmqARdO8drpDiPTB
X-Proofpoint-ORIG-GUID: 4sQQdBon4uTcOVKGmmqARdO8drpDiPTB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

________________________________________=0A=
From: Ziyang Xuan (William) <william.xuanziyang@huawei.com>=0A=
Sent: Friday, December 2, 2022 2:04 PM=0A=
To: Geethasowjanya Akula; Maciej Fijalkowski; sunil.kovvuri@gmail.com; Suni=
l Kovvuri Goutham=0A=
Cc: Subbaraya Sundeep Bhatta; Hariprasad Kelam; davem@davemloft.net; edumaz=
et@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; =
Naveen Mamindlapalli; Rakesh Babu Saladi; linux-kernel@vger.kernel.org=0A=
Subject: Re: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory le=
ak in otx2_probe()=0A=
=0A=
>=0A=
> ________________________________________=0A=
> From: Ziyang Xuan (William) <william.xuanziyang@huawei.com>=0A=
> Sent: Friday, December 2, 2022 7:14 AM=0A=
> To: Maciej Fijalkowski; sunil.kovvuri@gmail.com; Sunil Kovvuri Goutham=0A=
> Cc: Geethasowjanya Akula; Subbaraya Sundeep Bhatta; Hariprasad Kelam; dav=
em@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; =
netdev@vger.kernel.org; Naveen Mamindlapalli; Rakesh Babu Saladi; linux-ker=
nel@vger.kernel.org=0A=
> Subject: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak=
 in otx2_probe()=0A=
>=0A=
> External Email=0A=
>=0A=
> ----------------------------------------------------------------------=0A=
>>>>> On Thu, Nov 24, 2022 at 09:56:43AM +0800, Ziyang Xuan wrote:=0A=
>>>>>> In otx2_probe(), there are several possible memory leak bugs=0A=
>>>>>> in exception paths as follows:=0A=
>>>>>> 1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.=0A=
>>>>>> 2. Do not shutdown tc when excute otx2_register_dl() failed.=0A=
>>>>>> 3. Do not unregister devlink when initialize SR-IOV failed.=0A=
>>>>>>=0A=
>>>>>> Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload o=
n ingress traffic")=0A=
>>>>>> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mc=
am entry count")=0A=
>>>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>=0A=
>>>>>> ---=0A=
>>>>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-=0A=
>>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)=0A=
>>>>>>=0A=
>>>>>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/=
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>>>> index 303930499a4c..8d7f2c3b0cfd 100644=0A=
>>>>>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>>>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>>>> @@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *id)=0A=
>>>>>>=0A=
>>>>>>     err =3D otx2_register_dl(pf);=0A=
>>>>>>     if (err)=0A=
>>>>>> -           goto err_mcam_flow_del;=0A=
>>>>>> +           goto err_register_dl;=0A=
>>>>>>=0A=
>>>>>>     /* Initialize SR-IOV resources */=0A=
>>>>>>     err =3D otx2_sriov_vfcfg_init(pf);=0A=
>>>>>> @@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, c=
onst struct pci_device_id *id)=0A=
>>>>>>     return 0;=0A=
>>>>>=0A=
>>>>> If otx2_dcbnl_set_ops() fails at the end then shouldn't we also call=
=0A=
>>>>> otx2_sriov_vfcfg_cleanup() ?=0A=
>>>>=0A=
>>>> I think it does not need. This is the probe process. PF and VF are all=
 not ready to work,=0A=
>>>> so pf->vf_configs[i].link_event_work does not scheduled. And pf->vf_co=
nfigs memory resource will=0A=
>>>> be freed by devm subsystem if probe failed. There are not memory leak =
and other problems.=0A=
>>>>=0A=
>>> Hello Sunil Goutham, Maciej Fijalkowski,=0A=
>>=0A=
>>> What do you think about my analysis? Look forward to your >>reply.=0A=
>> otx2_sriov_vfcfg_cleanup() is not required. Since PF probe is failed, li=
nk event won't get triggered.=0A=
>>=0A=
>Hello Geetha,=0A=
=0A=
>If there is not any other question, can you add "Reviewed-by" >for my patc=
hset?=0A=
=0A=
>Thank you!=0A=
=0A=
>> Thanks,=0A=
>> Geetha.=0A=
>> Thank you!=0A=
>>=0A=
>>>> @Sunil Goutham, Please help to confirm.=0A=
>>>>=0A=
>>>> Thanks.=0A=
>>>>=0A=
>>>>=0A=
>>>>>=0A=
>>>>>  err_pf_sriov_init:=0A=
>>>>> +   otx2_unregister_dl(pf);=0A=
>>>>> +err_register_dl:=0A=
>>>>>     otx2_shutdown_tc(pf);=0A=
>>>>>  err_mcam_flow_del:=0A=
>>>>> +   destroy_workqueue(pf->otx2_wq);=0A=
>>>>>     otx2_mcam_flow_del(pf);=0A=
>>>>>  err_unreg_netdev:=0A=
>>>>>     unregister_netdev(netdev);=0A=
>>>>> --=0A=
>>>>> 2.25.1=0A=
>>>>>=0A=
>>>> .=0A=
>>>>=0A=
>>> .=0A=
>>>=0A=
> .=0A=
>=0A=
=0A=
Reviewed-by: Geethasowjanya<gakula@marvell.com>=
