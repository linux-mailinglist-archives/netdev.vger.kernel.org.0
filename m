Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2191BECF5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD3A3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:29:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD3A3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:29:12 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03U0IZXO009728;
        Wed, 29 Apr 2020 17:28:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wmHMqIvQ5Ed2ay7yUaiXRVMaNEiGf5PJWwOf6gIUvEU=;
 b=qvQHDCZNrHNyM6TC53ijmKvHlotc6HtYFKbOBAhIdYus1N1vcA4eE62RT2L7bKA65bC9
 mvgFmtch++sfh6Y9RbzESw8d1FisZqeDO40LiZ+mAWGtKIUT2RbudpkOl/T7KmwbRT42
 RbViFL61ASs79+ocUARS96hMZYZwiHotOZg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnyg3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 17:28:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 17:28:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIW5DEyq9WBQ3qDfNQYUu30Q7e0P1uWZAmHZqgS26gxTtSpaJtMDcvXc65JPORw2HniQAx5hhkz2bUnR88gmKeYWkoJoZkm0vLJx7fYqdxzKTtVF8Isk/3QMCZW6rUz3sJTCWGy6Ya86TdduJAq5A8Imsvymsp37xRi/Mc/IywCPCikYxRFznpehoiMu9rZ6b2bJPg8rLucVidnpIj+t28xiNNxBi7JCaHuIPWP+gotc3mzFfzL8PIVWB7oOKkITP1hwF0l+rdrk6ODEWUUym5IVafYqfeCGAY49diFy7NouiSAj8wo1q1ZnVph8yx919eA28iIFP8JY4x9md9ZSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmHMqIvQ5Ed2ay7yUaiXRVMaNEiGf5PJWwOf6gIUvEU=;
 b=H5Dr4yo9Mb9vPWexdEoMgonqBDGBRAP0I+cZd0/MCj0f7QWjLMRMGrhWS1PmCCSdY96sH/S4j6hDBoYuNMxDrNq6//m7DQcmNh8OC3sP41cEh7O/QOXwHSEqTkW/uBQ/7m+9v3BQrHxQznNgVOh1RaSI/UJIjOKYUQpY4MfocPOYypJdliD+47kRqImmzi6qsNhoRB5xVlGPsHvYAwcuRdzhgNBhnzJmGaer6l/rWPOsZkCeNPRlcGrJOQa0AsmTUXLdpFUC5hNRJweAdeSRaiqDrYoyN7zOuuLYX+SwSFJ042R8Hx01mZ04ZuBr2Tzk/eJzq7vHfXAOd3/Omu0lCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmHMqIvQ5Ed2ay7yUaiXRVMaNEiGf5PJWwOf6gIUvEU=;
 b=kWIqzLfHf7phtn7v0IKX+7Aa7q/WwyuWP1mP3mmw8Cyyia/HlZwNqTSSlartrlBO43rGj0b3/785twbP2qu4jAjSd0mK5GQPEaRgxydLu0Li55qxhZf7WJ1kD0o+rD+zYXVEUOtT8fvYzRRDLYr4v3bApraSrSDNUgc9GkpJyMk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3319.namprd15.prod.outlook.com (2603:10b6:a03:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 00:28:55 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 00:28:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v8 bpf-next 1/3] bpf: sharing bpf runtime stats with
 BPF_ENABLE_STATS
Thread-Topic: [PATCH v8 bpf-next 1/3] bpf: sharing bpf runtime stats with
 BPF_ENABLE_STATS
Thread-Index: AQHWHfHZBEsXJHNI5EqTeTxWQMOY4aiQwVuAgAAPaQA=
Date:   Thu, 30 Apr 2020 00:28:55 +0000
Message-ID: <5BF895D9-6761-45FB-BE78-034BB2C73C6F@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-2-songliubraving@fb.com>
 <77523dab-bfd0-45d4-0d03-26a07bb6483e@iogearbox.net>
In-Reply-To: <77523dab-bfd0-45d4-0d03-26a07bb6483e@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ae7a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab2c3222-5dc4-41ed-c7fb-08d7ec9d7751
x-ms-traffictypediagnostic: BYAPR15MB3319:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3319E533170F554249A19FE0B3AA0@BYAPR15MB3319.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(66446008)(64756008)(76116006)(66946007)(2906002)(91956017)(66476007)(5660300002)(6916009)(66556008)(478600001)(4326008)(8676002)(53546011)(186003)(6486002)(36756003)(2616005)(33656002)(86362001)(8936002)(71200400001)(6506007)(6512007)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iyqkiuetjcqquvpvqcllpW2ZkREBBe2XKog6o+3BMrjfSIKrHInobbJ8GyiP781jAm2tvHlcA7nHMJHjX2lFYm0AE6E9NUWCxZAx7aLBJ9LOxTimubLAlJHivluF8e+ztCmE4xwLm4pcH+JIqUm2WJYf98IMTyrkcDWi4m8ksdkDGc2NfDrG3VZkArLl24KhHy5QHLQIYmI1vKs3YofIppJE16vpDAONuUAmkhrVV8Rh9pc+zIKK2aCrhRpOM53wiQuA6hUQCC5b79tQFoygo87QbWOgReMNgoASCITpyHt/T2q4tRx9XgPywavuEcKWiPDZqcucdM1PzZiJaUNs8eX//HV3xGsluK98YQc2RTcVNltpTWBBrQm0oOy6awYLHTCWSvfx4KClRZC1dQp+HPo/E3HCUNZr/K00mUGz+lvNZKziud1WlT2whPWbRTQC
x-ms-exchange-antispam-messagedata: ptzphgZ0sMnNsdda9Qu9pgtZR5Mc9Uk/iFxahTAABx4gtHU/y3EUuid0/5YIsgWJlWWGYFNscC8GAsmrduzm7Gl+Sj6TpsPxGsd6d+BH1IP/sklAKXMYAmSwLjEBFdJ4KXbxjeEhyaZvPwwasJN9gEX/aEgHLO9uMbC0e1dARyBiQi2vIaM21KHQAhAOsngBVYSv+6Zwx08Nw6IuMFvdqQ27wtY9Rlgw4aMxlPfOTF5ynLWHLN/iN09PvMTLX7FuSbrO65z/cOLdEA+cz7PW25UFZ6Ke6VKNdH/99MSwbx0qxLIVK9Llrxs/cZA9BqLzjDTgNYU8zDg3Uuz+CcftH5xMBIXdivPe2BxqMKEVty20+FLbXOGJGRVrCnGapuuLvaCrR985wfsleQzdUFr1G3/IHBTmx9NW8hvCC0r04fhw08pvtj3vxy4DOOL5RnRsFJITb1TdCwP7xrUyphi+M4UBPA0Ptgxxci5QsbfCZbP7geHe0PX1kG12uZxq0d3Hwr/oKnCtdac1O79jQRUxH0RX5JKi9UhMP4o/7z8z5+dH6wUSNIr891R7R0aNJFloleZ5K8su+8B6ehctECqXHEbeat2YfhTsbTjRajzbI2dCGODJc7GdP0ehLNiCNdhjbve+SWkNzXFzXT2vK3AN7gaeJCBeQBWWXgNH/PBub4aC8PvphtmRXEynhKb/Y/b/IW5U+VEJq55qau/lStQfong4u4uVxOpTeC70Nrh1hf0DUKbwRKwTnOHjRCbr0TW15j/LMy/6x4nTvJInBcibbXIahVh/J34cCjhNWarHQaeyTngGiYH7YLW6rcNRmtVg0bfJow05qPKtga11J8VsoQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01E60669E903A843BEA2321504CFE67F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2c3222-5dc4-41ed-c7fb-08d7ec9d7751
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 00:28:55.1593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eaDm1MRcxvtbkceLagifILc2djCV+49Ezb5S8lfrp9DrOkaVFMmzQWjC6ZUqwB0txhLISmkp3uolasP1euCuTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3319
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_11:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 29, 2020, at 4:33 PM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
>>=20
[...]

>> +
>> +	fd =3D anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, 0);
>=20
> Missing O_CLOEXEC or intentional (if latter, I'd have expected a comment
> here though)?

Yeah, we should have O_CLOEXEC here. Will fix (unless you want fix it at
commit time).=20

>=20
>> +	if (fd >=3D 0)
>> +		static_key_slow_inc(&bpf_stats_enabled_key.key);
>> +
>> +	mutex_unlock(&bpf_stats_enabled_mutex);
>> +	return fd;
>> +}
>> +
>> +#define BPF_ENABLE_STATS_LAST_FIELD enable_stats.type
>> +
> [...]
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index e961286d0e14..af08ef0690cb 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -201,6 +201,40 @@ static int max_extfrag_threshold =3D 1000;
>>    #endif /* CONFIG_SYSCTL */
>>  +#ifdef CONFIG_BPF_SYSCALL
>> +static int bpf_stats_handler(struct ctl_table *table, int write,
>> +			     void __user *buffer, size_t *lenp,
>> +			     loff_t *ppos)
>> +{
>> +	struct static_key *key =3D (struct static_key *)table->data;
>> +	static int saved_val;
>> +	int val, ret;
>> +	struct ctl_table tmp =3D {
>> +		.data   =3D &val,
>> +		.maxlen =3D sizeof(val),
>> +		.mode   =3D table->mode,
>> +		.extra1 =3D SYSCTL_ZERO,
>> +		.extra2 =3D SYSCTL_ONE,
>> +	};
>> +
>> +	if (write && !capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	mutex_lock(&bpf_stats_enabled_mutex);
>> +	val =3D saved_val;
>> +	ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>> +	if (write && !ret && val !=3D saved_val) {
>> +		if (val)
>> +			static_key_slow_inc(key);
>> +		else
>> +			static_key_slow_dec(key);
>> +		saved_val =3D val;
>> +	}
>> +	mutex_unlock(&bpf_stats_enabled_mutex);
>> +	return ret;
>> +}
>=20
> nit: I wonder if most of the logic could have been shared with
> proc_do_static_key() here and only the mutex passed as an arg to
> the common helper?

We have static saved_val here, so it is not so easy to share it.=20
I think it is cleaner with separate functions. =20

Thanks,
Song

