Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23A8DB6BC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407122AbfJQTC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:02:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728796AbfJQTC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:02:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9HJ2TRO025165;
        Thu, 17 Oct 2019 12:02:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=p1IuVNv2X64mMu9EK97GPvvCbpV52kTmI8oWYIFDkxI=;
 b=L50ZtSDqmdL3qKtJ17C2hKp63IjUXBRYW9/p+cYHeNJW3ZAQY+W+VYkqdjBo1kmijWxe
 DAzs/kbYkgBmFD0ZHui9REudPDnFjAkdMOsFT8UrXYnqO6JoRuid24eeeM6AaeEYLjkn
 8KJblLGu3DTbO5WFmHkvpEtfgnRMQr17Eqk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vprq99qha-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Oct 2019 12:02:36 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Oct 2019 12:02:23 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 12:02:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xpu+21cbeDfaFQkj7aEKtxFLOdJe4a2HoUWcRtxGZkUhK8IM1NrBzaNw3Xu5T+nwYaWuH6UggbI78K8+Ms87r+cduYIolh5jTdygYlZD2O016Sb7iYgD0oQ86Mq4OTUBjvB+geCqoC7wa3GAagnQuABTnTCluRkjA1GSZa2J+RpW5tvft1t09GUVRaU3MOdOKuK8uAlwwON/rHIDVRNWbq4+Ue3YfxETP3QRN1x2cCFMx85BmEFW8p0vmVfDhNUGRXh4fMGGsnm/OZ+tUw9wjtJLypkhjkyrdd0dxLcrcIRxOiXQcF2YSjib2xo1JhNr6otkKeu5S5k5h0NuUqnXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1IuVNv2X64mMu9EK97GPvvCbpV52kTmI8oWYIFDkxI=;
 b=csK91K72oYIOxYYls4Sbp0nNSJV/GlGazMrtFncxIgz6Q4v6aisiMfPk6u8FmYi4Ex7uOi2EKgywOYetPtpCX4Opuekj87mNVL1Rj0UqwQt35Q+7nAQrydqPqaFo5Za0SJgzp571bmfoPk8cziH5xAEA5dGnwvTfTCMYPqu45u3ElVGvIH5FGhiR6PCIHbwTqJQG7pWntH8kFpEzpsXsciAMViYI960q3IjXm/PmW/NQcC1Us60PwAyCbPi28pXEfV67XMPZMZDjQqnzaCn4NoVn2cSp7JW5BPacKWjbPxZOqy6pfC5HF4WscGQiSn8IVCF0091LVzxY9gp6vEzV8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1IuVNv2X64mMu9EK97GPvvCbpV52kTmI8oWYIFDkxI=;
 b=cA/8h10CMvgMn6KZ/Ui4bGfh4hvh1HOczlCHF6hxLfyrwFHWA46k3UH7pGKrLtr7elxxj0WtPGvnb8PeDv1LiP61aLqAIUesp5rQGPSgsCe/ZnZqgqeKBk5BfSY8omwOIAakvboy9oJPVPECiZv0Y+1KINjklEfxX/yzasSmROE=
Received: from DM6PR15MB3210.namprd15.prod.outlook.com (20.179.48.219) by
 DM6PR15MB3609.namprd15.prod.outlook.com (10.141.165.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 19:02:22 +0000
Received: from DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856]) by DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 19:02:22 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhNkLfZlWSO7mI0yzFNGdtyQQtadfMRqA
Date:   Thu, 17 Oct 2019 19:02:22 +0000
Message-ID: <20191017190219.hpphf7jnyn6xapb6@kafai-mbp.dhcp.thefacebook.com>
References: <20191017105232.2806390-1-toke@redhat.com>
In-Reply-To: <20191017105232.2806390-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:300:6c::34) To DM6PR15MB3210.namprd15.prod.outlook.com
 (2603:10b6:5:163::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee07]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc72d716-0426-4d61-ab20-08d753348a6a
x-ms-traffictypediagnostic: DM6PR15MB3609:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB360928661C3A5B4F547F65CFD56D0@DM6PR15MB3609.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(376002)(39860400002)(346002)(199004)(189003)(8936002)(9686003)(6512007)(81156014)(8676002)(81166006)(25786009)(6116002)(7736002)(229853002)(305945005)(2906002)(6436002)(256004)(6486002)(14444005)(102836004)(6246003)(186003)(4326008)(476003)(6506007)(386003)(71200400001)(54906003)(11346002)(86362001)(1076003)(76176011)(52116002)(66946007)(71190400001)(486006)(446003)(478600001)(66574012)(316002)(99286004)(64756008)(66556008)(66476007)(66446008)(46003)(5660300002)(6916009)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3609;H:DM6PR15MB3210.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GLZDWFy5Lgf8Cqrj6MAYMxPApexGDBAm8RUEUgKIpaDmGfTTGByZnW5PhVoshbvEcoP2lCvNwDEn4ERFOlAT+KZimjDaKF+yysHUTT8U0xI9eGtS0oU3zHXo6LA3G3g7EpeHSmULLlACtvxkLced6HBDOsx7ytsAmQoPxIpmkOjrjz6B1QgQ/oDezarDJwWIzGNt+MIkS9OQt7Q76SP9vfpW5OF8jyDm7GsYNwnfKDCeTfTfFptSa7HI1TI+UCCsARZ8vmtW1ruWslfXLmt50g2pOF40uE2gCYrHXvZr+2EbXxeerruMvu2TRp5h3zykPpgg18vLAXz0sHY6/niAkduCD26aXT8V7pnGqks6uAQ1nXAL+DN/fGfBYZaAVCN1UnT7JybXKrdNqTp42l7RInXHHkf//9gxk1BMnFoiS3I=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B3F3E6A7ECC9E64EBE53C1BB6E1A8909@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc72d716-0426-4d61-ab20-08d753348a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 19:02:22.3684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RTwIc/mqa/auNX7G2s62/Dwfd5EbOjHolQu+wjTayrbHQMxiNSgRbOqITvlyHqDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3609
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=761
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 12:52:32PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> It seems I forgot to add handling of devmap_hash type maps to the device
> unregister hook for devmaps. This omission causes devices to not be
> properly released, which causes hangs.
>=20
> Fix this by adding the missing handler.
>=20
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up device=
s by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> ---
> v2:
>   - Grab the update lock while walking the map and removing entries.
>=20
>  kernel/bpf/devmap.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>=20
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index d27f3b60ff6d..a0a1153da5ae 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -719,6 +719,38 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>  	.map_check_btf =3D map_check_no_btf,
>  };
> =20
> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
> +				       struct net_device *netdev)
> +{
> +	unsigned long flags;
> +	int i;
dtab->n_buckets is u32.

> +
> +	spin_lock_irqsave(&dtab->index_lock, flags);
> +	for (i =3D 0; i < dtab->n_buckets; i++) {
> +		struct bpf_dtab_netdev *dev, *odev;
> +		struct hlist_head *head;
> +
> +		head =3D dev_map_index_hash(dtab, i);
> +		dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
The spinlock has already been held.  Is rcu_deref still needed?

> +				       struct bpf_dtab_netdev,
> +				       index_hlist);
> +
> +		while (dev) {
> +			odev =3D (netdev =3D=3D dev->dev) ? dev : NULL;
> +			dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&dev->ind=
ex_hlist)),
> +					       struct bpf_dtab_netdev,
> +					       index_hlist);
> +
> +			if (odev) {
> +				hlist_del_rcu(&odev->index_hlist);
> +				call_rcu(&odev->rcu,
> +					 __dev_map_entry_free);
> +			}
> +		}
> +	}
> +	spin_unlock_irqrestore(&dtab->index_lock, flags);
> +}
> +
>  static int dev_map_notification(struct notifier_block *notifier,
>  				ulong event, void *ptr)
>  {
> @@ -735,6 +767,11 @@ static int dev_map_notification(struct notifier_bloc=
k *notifier,
>  		 */
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(dtab, &dev_map_list, list) {
> +			if (dtab->map.map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> +				dev_map_hash_remove_netdev(dtab, netdev);
> +				continue;
> +			}
> +
>  			for (i =3D 0; i < dtab->map.max_entries; i++) {
>  				struct bpf_dtab_netdev *dev, *odev;
> =20
> --=20
> 2.23.0
>=20
