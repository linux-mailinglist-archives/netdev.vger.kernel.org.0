Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1C640099
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 07:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiLBGi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 01:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiLBGi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 01:38:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF158013;
        Thu,  1 Dec 2022 22:38:24 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B20K9we015716;
        Thu, 1 Dec 2022 22:38:06 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k71576v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 22:38:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtohxRCf/30/74FXP+2dWTjgg1SBACNP9ScPgFG5HBlIlz+WGRmBQkcp03dwL+fvSm1nTmXCcbUU8jrco/HP8FVBbt0uJMmRydBqydHdWcJ1ygnYk0EHcqaIoE6MygvwZxqv4jjMf8A9xA0Iqb3zhdHoYderGrQrLHL6zF6pI5UW7Mp0920AcTGqaWLDRFoSTnDL63VeF5EVhJo7iTE47NCvxVJcStG3BBtEvLC8zi6r3eKJ9ZxZWRDyXHRkO73VRA6bkukVDa2u6FnCEgquNgDEZnmI1eNu4DGcwTTUZrgOPOrmSqT3uMEmcFI1dN3N5mSwqX03a55q0rV8GQe+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQRJRGGzLCL45gypbQg5LtlLpp4b1Bx9FT7OJHXLzpY=;
 b=WEEip79nEE/2WmiSWyOUzx/Sjdbm8+WSxMBF/PPQ4ZQbqe72FKj8PWZ3dLer+eB07c8hgS/RZf8Z1++7pEXj2gaI0cAHNA4UYOvJ5ZIgAJPM/I5nLEmiwWoEQSOzbXXwpgJG7jJ9V7SlubG15aSUaQT67tmHW69Yt6woeNCPL9uXbJ4iaMz5cACiRdYeHlq0c8mYep6T2IyebvsoqWTgDWdMXh8KuhXWEWp6iPVkXnPH77CCI5sMi2QzcFMQ0Rb7tcPqDH4A6aE6p9kTMQLFbY+kPtBXINKOp1aznV1lsiSfassNzOwbYtRoLughv6aQrZxz6g6440vQC+Vhn/jNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQRJRGGzLCL45gypbQg5LtlLpp4b1Bx9FT7OJHXLzpY=;
 b=LbLN0LqxBXKp9OSwwBSH5b0gPpcYt8tZjuYr4Fs+5tRACSGwhaUh/hc79ndrxofOHDFMJsEh4nnhSh0/PvGQgVFc1C0BgRmBpss69DDqN+Nwa4YTR/C6UqVMeD671qIRP5UQIort6WPxrob3uO8TnK8vhxbwv4N4yH8cv9KXTp8=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by MW5PR18MB5175.namprd18.prod.outlook.com (2603:10b6:303:1c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 06:38:01 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 06:38:01 +0000
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
Thread-Index: AQHZANRUZLikb9cSFEyd1JlStS0yCq5QZIkAgAl5CwCAAFBxXg==
Date:   Fri, 2 Dec 2022 06:38:01 +0000
Message-ID: <DM6PR18MB26020F45167434B409A32AA7CD179@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
 <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
 <Y4DHHUUbGl5wWGQ+@boxer> <f4bb4aa5-08cc-4a4d-76cf-46bda5c6de59@huawei.com>
 <538c8b9a-7d6c-69f8-9e14-45436446127e@huawei.com>
In-Reply-To: <538c8b9a-7d6c-69f8-9e14-45436446127e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|MW5PR18MB5175:EE_
x-ms-office365-filtering-correlation-id: 45f2895c-5daf-4162-b9a1-08dad42fc249
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xp0K1vLYca/fLIaI6oB5g4OjAHlkiUMilq77QdHunf8thlMVcftmedQZBOQONVlE60LK437ALFGThHe86edN+DCk3KFnpxOQcPWdfm5itiQY8dzj3uKA5Qa7anndPKY8iyKIN0C8eUZHKkRCkfn1JmcZIW0C8uvKaha0tYDDKFV1GRIvZXzWW76a06pI79fMKO4Wxdmm+Ojl0JCWNPLhBkk7Vu/vYhm+Gi53uXGP+00VWp8H2a2CSyrASi3uuocvMg2RpclasnUdaHALmMeAkxn5vW4hX0X/j76D7SmBhMpuyRn6nQ2VTs1ECTrYI4Hi+swGCxd8YKox3uMo8g3NblKCjW44t+COeCtcebJLNDsDWWuAEZmOYZ5yGi8tFlsGgwrEFZj5CLzamOR0E0/zSLVKVGXoCW8n0uWgRwPnAX5MXsRl7zsZKvSBQjxoGT/sSTlGX0WxTKciIdep0yDs+HuaATi8XexEl5AKB11nbeMYUbUd0jPQsEOW+aeYYsTC35449i/MtPPmHesyvfpqpkQoYq4S7XLzpQIvBVi+1A6r+RGe0tiduZYwKVI+3kcKVscY0X/mOFZ4wnxE2lT64kZWwVfqu8FUl0KsgrnVB11V4v28rg+HMU2WPHrDVIF2eGD9hrI18HXkZJOO9nl6ti9my5h5iXEihsRTHJIBrmAbl+a1Ef9jeq29g+Y9A6EL68UB965tLsepmLrEdHeJYm92Zx7WXKA//ZZ2jYzsnm4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199015)(71200400001)(33656002)(110136005)(66946007)(54906003)(4326008)(66446008)(66556008)(64756008)(8676002)(6636002)(66476007)(76116006)(316002)(91956017)(83380400001)(55016003)(38100700002)(38070700005)(53546011)(7696005)(122000001)(6506007)(478600001)(26005)(186003)(86362001)(9686003)(5660300002)(2906002)(52536014)(8936002)(41300700001)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tAaNQNvfbj9fqaOQoXa9hkoqDq965dLXje//U+Sr3KQc3Qvx3/sVO5Swyv?=
 =?iso-8859-1?Q?UM9pPGdpi8bKOLRHCQaGV0h4WNecfn2nSkxeANx7960i5j3Nr9GCTUPzeM?=
 =?iso-8859-1?Q?7JOQoaVb48Il7iS13iiErnfUh1KZzn9pH028R241dnoyYqlNcaWmocv70g?=
 =?iso-8859-1?Q?rPDQDs9YNFKRlXwDUbJMg/zH6GB1e6tGPcVV6dozKlJIw7gBYYPeNNMf6s?=
 =?iso-8859-1?Q?QG0RCizaaDfsksuOMJX6LkgRjNy9k5RqndEId/0iWFlBfyAVpDBg4iPQzs?=
 =?iso-8859-1?Q?iNcDk+QkSELRKSr1QQ5A7Y28P2xUWbCyBZ57Of8xVD3MpHvMpMAj+YsNfS?=
 =?iso-8859-1?Q?aAsKlJYYr9nl1GenIKDfK4qpGbSV541btepto8jbX43SON8miadqM8tEQf?=
 =?iso-8859-1?Q?XHppEm/ZdpKJvi6v1zKsiotFsayTuGxEW5P6RPLdYhlKw1gcLrfJcQ11jC?=
 =?iso-8859-1?Q?E1MugXpEVfEdVPOPPMfmEJ1o90pAG1Rv2u4ulPERaXVeDdJXvxZMpYGg/K?=
 =?iso-8859-1?Q?giIt0l/R2fUeS9Qi3MzT9I2NMJgPPybdoEE4BRCBUhApwG1smsvHrmJuHu?=
 =?iso-8859-1?Q?H24xhAgsH3OXBDgmabN8V8FcFC5Vg3pALSmP9mypj6yxxzS4hBksd/sL70?=
 =?iso-8859-1?Q?ybMzTiXEk7/9HbAffg2KZOaeZ652n/3sEv5EKbVmTRsKyaT8Fr+/WSPEVS?=
 =?iso-8859-1?Q?QQOTnayD7MFLbhPwKi2+JMgXr5wA3KLfM09T5GeeoPRD1XdEgQEHtz9ceq?=
 =?iso-8859-1?Q?F/jKENAPOCeLTPeqpWSCnB/SH8XHdgsXTEruJfaydF4/bPb/hWRjqGwKm4?=
 =?iso-8859-1?Q?LAz8N3jc9y4i9s9oQ4EEkhhpU1ipH0Fo5jgo3p/xIPlZMP2prIVlv+py1j?=
 =?iso-8859-1?Q?p7j5T7yhAujB5gNx5yuSJV2yEyHngShj2+TCwRa0rdXpboASbw5NFqlDyp?=
 =?iso-8859-1?Q?Z2k3pvdf3nfF64njlQ2F+fc/hw9Hf5MIoHx9IkeoVbFXuT/y5nSZ9tHLlZ?=
 =?iso-8859-1?Q?E89m4pI1g17a5lcFyI1k5hFJG7YAK31FCj0ROPgNNZFMDtDXz0iSB7dF3+?=
 =?iso-8859-1?Q?3+BTTLNolpPZCBEU9uhj+sU2raN6J4N9EBI1g9JfuhUdYgqcRUCQHPfp2F?=
 =?iso-8859-1?Q?OaVDIK4DxkNdCwux6NISwCXrizWSjsSqSzIyDOtIPEIP2i6s7CnNkhQZzv?=
 =?iso-8859-1?Q?if88ROpJTcs7P+Np/2lTqSg3FOq9Ge02KdFEt43ShbBRjVsdpJTvUIMLin?=
 =?iso-8859-1?Q?dfgcywzufm6URP0dwYXRPZsKxfu8D0gVoJMZFCVxSz9T3VsUScNh17yi9r?=
 =?iso-8859-1?Q?zN/DqIsmJQl1bzI64ys3oThVWMyGMU4kAoEK84b7REkJjlWGuefPCx7Ggz?=
 =?iso-8859-1?Q?/lsDI2aS6v352R8FRGhsZJuH6zqJsAStvlJmxQngPCJkMa5dvTxy9VHl9e?=
 =?iso-8859-1?Q?wi/BQreEpd9h2vCVYbilGSd3OtEinnkoQinBOVM0ezR5VBAkKQEYBig0F4?=
 =?iso-8859-1?Q?44qlxPZG9HrQuui6izx0dcxXmaqKPEKtHdR3uXy1QHONV3Sm7C+tUnObf1?=
 =?iso-8859-1?Q?gFjInngYGccwUAjAbpYhNQpncKi+cI1KMdYKmA3uT+CRCf1RuTsneDFDCb?=
 =?iso-8859-1?Q?h2O8cKaYAO970=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f2895c-5daf-4162-b9a1-08dad42fc249
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:38:01.4353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0C69HoELK9RL94nttLpqUbumjTkiwk44TWyOgvFh+iEuev4jw2jBy/mBlLWsEdYouGPD+wp40PKNGzwLNtfiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR18MB5175
X-Proofpoint-ORIG-GUID: qcYm_5sOguE2gCBmJ9859SfVBecdqfrU
X-Proofpoint-GUID: qcYm_5sOguE2gCBmJ9859SfVBecdqfrU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_03,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
________________________________________=0A=
From: Ziyang Xuan (William) <william.xuanziyang@huawei.com>=0A=
Sent: Friday, December 2, 2022 7:14 AM=0A=
To: Maciej Fijalkowski; sunil.kovvuri@gmail.com; Sunil Kovvuri Goutham=0A=
Cc: Geethasowjanya Akula; Subbaraya Sundeep Bhatta; Hariprasad Kelam; davem=
@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; ne=
tdev@vger.kernel.org; Naveen Mamindlapalli; Rakesh Babu Saladi; linux-kerne=
l@vger.kernel.org=0A=
Subject: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak i=
n otx2_probe()=0A=
=0A=
External Email=0A=
=0A=
----------------------------------------------------------------------=0A=
>>> On Thu, Nov 24, 2022 at 09:56:43AM +0800, Ziyang Xuan wrote:=0A=
>>>> In otx2_probe(), there are several possible memory leak bugs=0A=
>>>> in exception paths as follows:=0A=
>>>> 1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.=0A=
>>>> 2. Do not shutdown tc when excute otx2_register_dl() failed.=0A=
>>>> 3. Do not unregister devlink when initialize SR-IOV failed.=0A=
>>>>=0A=
>>>> Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on =
ingress traffic")=0A=
>>>> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam=
 entry count")=0A=
>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>=0A=
>>>> ---=0A=
>>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-=0A=
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)=0A=
>>>>=0A=
>>>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/dr=
ivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>> index 303930499a4c..8d7f2c3b0cfd 100644=0A=
>>>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=0A=
>>>> @@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)=0A=
>>>>=0A=
>>>>     err =3D otx2_register_dl(pf);=0A=
>>>>     if (err)=0A=
>>>> -           goto err_mcam_flow_del;=0A=
>>>> +           goto err_register_dl;=0A=
>>>>=0A=
>>>>     /* Initialize SR-IOV resources */=0A=
>>>>     err =3D otx2_sriov_vfcfg_init(pf);=0A=
>>>> @@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)=0A=
>>>>     return 0;=0A=
>>>=0A=
>>> If otx2_dcbnl_set_ops() fails at the end then shouldn't we also call=0A=
>>> otx2_sriov_vfcfg_cleanup() ?=0A=
>>=0A=
>> I think it does not need. This is the probe process. PF and VF are all n=
ot ready to work,=0A=
>> so pf->vf_configs[i].link_event_work does not scheduled. And pf->vf_conf=
igs memory resource will=0A=
>> be freed by devm subsystem if probe failed. There are not memory leak an=
d other problems.=0A=
>>=0A=
>Hello Sunil Goutham, Maciej Fijalkowski,=0A=
=0A=
>What do you think about my analysis? Look forward to your >reply.=0A=
otx2_sriov_vfcfg_cleanup() is not required. Since PF probe is failed, link =
event won't get triggered.=0A=
=0A=
Thanks,=0A=
Geetha.=0A=
>Thank you!=0A=
=0A=
>> @Sunil Goutham, Please help to confirm.=0A=
>>=0A=
>> Thanks.=0A=
>>=0A=
>>>=0A=
>>>>=0A=
>>>>  err_pf_sriov_init:=0A=
>>>> +   otx2_unregister_dl(pf);=0A=
>>>> +err_register_dl:=0A=
>>>>     otx2_shutdown_tc(pf);=0A=
>>>>  err_mcam_flow_del:=0A=
>>>> +   destroy_workqueue(pf->otx2_wq);=0A=
>>>>     otx2_mcam_flow_del(pf);=0A=
>>>>  err_unreg_netdev:=0A=
>>>>     unregister_netdev(netdev);=0A=
>>>> --=0A=
>>>> 2.25.1=0A=
>>>>=0A=
>>> .=0A=
>>>=0A=
>> .=0A=
>>=0A=
