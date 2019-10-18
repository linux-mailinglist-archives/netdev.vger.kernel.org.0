Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49E8DD0FE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439665AbfJRVSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:18:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390763AbfJRVSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 17:18:39 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ILA5KA031423;
        Fri, 18 Oct 2019 14:18:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fc3tbpcnEeKSGNZ6t+hn4FAV/SO3NZd5g4g5I7tXMok=;
 b=HRGJo09ACK+6dPw9J8bB4zuRVrPiiHMZvWUVohfAAqZ8J7p8wfuGm+QwYmec7ypHbybe
 eyx4HnfeJzb6cOvCgkwbOCjgLhB+WzoSqCP+lrw0o/5mXxl3QOneeJt1JJ48OS2S1gSt
 5kM6qtI1BPXtEBFG+t1+IXMuyNBaM9N6kUI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqfethsc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 14:18:24 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 14:18:23 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 14:18:23 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 14:18:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaMq7l4AZ6yzyPKXVHqIHEerHHo6e265XbJKvyz7IObqJGO7lAmE2AwzEMQ7PjX11pGyh/9jKSB2hcP3uB66S/AyptBFZv4sQGG9CaFVfMESQDgyUIbTzJv5THnphmfGGOuEoXHyN3eR+gM94u7L26NuCuJTaADUfaoWRZ1qh/dynyOW3fA+9rNxICtTXMLOYce2tpuCgryZaAJlUC0uRN7GvTyxWovXzptDdkLu2wBsIt1BTy3efwTXnPyHQc0Bg7h79Z7JLzHLd/nrMkTFfa02DpihUCNqDudJv1kgIDmzbcvfvt/Vt+ThJjSOUsotAKsd/9fGXYJ2JZtF6wiNCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc3tbpcnEeKSGNZ6t+hn4FAV/SO3NZd5g4g5I7tXMok=;
 b=fXlaILzNT4OL5PfVWusLYibJt9rvr+p+pxSUAx3Do0ZTybFIfYVQw8J62+0dr/txWyX8vYH/cwl5GsTOLx1V9DxjXNq/UtLYv8//4+H1JtDaWQLsuRU4FYOcQxu3VN6vFTYBIeyIIz4Z6gqxyLIoqjwsD5ykYq0ggrPl3QVYv+XHs1Dekm0xb4aCNoKdjTLRWJZC7hLGaA6Xi0YKRz/E7iooifcicovqwbYY2QKMNKWp+jVmu9UMA1me06DirmN8WIweditnlEw50ytIOaRrgl4y+3I8fu5WUxLVmlM3lLX3SvNaZjdri5+KplRf1Bk/w1kgx1TDiNVKAbdWCjp3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc3tbpcnEeKSGNZ6t+hn4FAV/SO3NZd5g4g5I7tXMok=;
 b=LM7hQiq2wSzNH45kk/Bwi/7HRCisQu8pksYhbDJEgGgNLuciatWEbH2V0k4GD1Nk9OjSh14W/TsA4o9UGoBNNsheXY+r6mUq1Xtu5du0UuTz64250XUJ2VDxJtKTuush7G9L/CdX3nEGUqhvD/tR/jI/d0WRh3XQ+4yjNp5KGN0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3134.namprd15.prod.outlook.com (20.178.250.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Fri, 18 Oct 2019 21:18:22 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 21:18:21 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v3] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf v3] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhex8Q2w7MSXc4EKgdk2tmnyXYKdg50YA
Date:   Fri, 18 Oct 2019 21:18:21 +0000
Message-ID: <20191018211818.5e6gfdjwq4zefnez@kafai-mbp>
References: <20191018194418.2951544-1-toke@redhat.com>
In-Reply-To: <20191018194418.2951544-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0072.namprd14.prod.outlook.com
 (2603:10b6:300:81::34) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::51a5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53682d45-2450-4894-a679-08d75410b435
x-ms-traffictypediagnostic: MN2PR15MB3134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB31342AE87EFBD8B08C3028BAD56C0@MN2PR15MB3134.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39860400002)(376002)(346002)(366004)(136003)(199004)(189003)(6486002)(478600001)(52116002)(66946007)(6436002)(8936002)(81156014)(81166006)(66556008)(6512007)(4326008)(25786009)(9686003)(8676002)(99286004)(14454004)(76176011)(64756008)(6916009)(66446008)(66476007)(6246003)(6506007)(5660300002)(2906002)(229853002)(86362001)(305945005)(71190400001)(7736002)(54906003)(486006)(186003)(446003)(1076003)(33716001)(46003)(256004)(102836004)(386003)(316002)(14444005)(71200400001)(11346002)(476003)(66574012)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3134;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guw0k9oC5TtoYEoKbK9jGQ/6xw5GYPFiCifH96xXFHThnFv1DSjOjVwjCZb0pSfsAEBADQWwD/Mxuam5GHfVXE2yQMrduhO9HCFK9VaLJQBW9bKuCUTb0QePD88MNVMnxlV/v954pbRXQ87B9qFTN5wuX+TtdcJFWN3ZMJtV0gUX3VSszo90yIJnqdiYmzwfXx9frzcexeAZxf6sA4ztkPqr/CSDlMd1+HWkNcb/e9ZGX6xqV4b5i5Ajy86FXNTBPd5Qky27UoEoZqyNwye/UfBvHfdZ6FceIQdDnjpgCTL+ECuktb7al5oyqrJPr/qU6AxqnzO5HlTvIRldfWLPoEE+4qs7ujRTMCP+fVfq4GQhvLMhfpTbDpuN50iFqYzFN2PwvoDf86/0joj9SjGKKKL+xZvNAKn4D2JwTyseK40=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <88CF945621442849B5E53A9B2887DDAB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53682d45-2450-4894-a679-08d75410b435
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 21:18:21.8917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUmXRyPjiFs2woP8uGK/E2pXD3hCfRE0XM7XFJqeUWRLljF1lBk+MUE5UtrvaWbG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3134
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_05:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=983
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:44:18PM +0200, Toke H=F8iland-J=F8rgensen wrote:
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
> v3:
>   - Use u32 for loop iterator variable
>   - Since we're holding the lock we can just iterate with hlist_for_each_=
entry_safe()
> v2:
>   - Grab the update lock while walking the map and removing entries.
>=20
>  kernel/bpf/devmap.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>=20
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index c0a48f336997..012dbfb0f54b 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -719,6 +719,31 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>  	.map_check_btf =3D map_check_no_btf,
>  };
> =20
> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
> +				       struct net_device *netdev)
> +{
> +	unsigned long flags;
> +	u32 i;
> +
> +	spin_lock_irqsave(&dtab->index_lock, flags);
> +	for (i =3D 0; i < dtab->n_buckets; i++) {
> +		struct bpf_dtab_netdev *dev;
> +		struct hlist_head *head;
> +		struct hlist_node *next;
> +
> +		head =3D dev_map_index_hash(dtab, i);
> +
> +		hlist_for_each_entry_safe(dev, next, head, index_hlist) {
> +			if (netdev !=3D dev->dev)
> +				continue;
> +
> +			hlist_del_rcu(&dev->index_hlist);
There is another issue...
"dtab->items--;"

> +			call_rcu(&dev->rcu, __dev_map_entry_free);
> +		}
> +	}
> +	spin_unlock_irqrestore(&dtab->index_lock, flags);
> +}
> +
>  static int dev_map_notification(struct notifier_block *notifier,
>  				ulong event, void *ptr)
>  {
> @@ -735,6 +760,11 @@ static int dev_map_notification(struct notifier_bloc=
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
