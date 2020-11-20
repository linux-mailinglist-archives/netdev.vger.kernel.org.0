Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B352B9FF3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgKTBqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:46:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4762 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgKTBqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:46:21 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1k3AA024561;
        Thu, 19 Nov 2020 17:46:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iD18ZlPdZeu/fSqQO2GVNXCL0F9aTyNHq5O59u2AHO0=;
 b=p29fzpT0YryOiXLGRBIcC0KlisUywSxM2zC+HtgZLthsMT7U/D2vuVx6Jqs6NurW/gPZ
 A7EUc+PHdJXojywHrEo7vrINmwwoBJEnXH9uL0SfSmdYDtGXz0VkZvq9hF5l2e0ld6bX
 LBHpHtuAMTzyZpScmf+yOMY1PLXXtVzO+/U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wjmxfexs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:46:04 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:45:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YacwEWHb+3Ha0bcoBx9WSpPIep6FritNVUa3e+PZEN6h3a2kD4AfmzqBk1z5t1Q2JlVRMC8V2O+8Gy+y2XQbI9D5HzvNZS5hdUDHFgcsS+vwze5DnccLabPGY8Z+6IJzfxNqemcNhor1XuR1IvJvxrD2gK1b8FYsRhACnbKYvF97kVecIGeyDcEjz2mBry6AafY6dO+xBCexcFJ2Blejg6v9zJMcWwnB6dVvYBWZqyfuldSozOK34n/kloHzaMRSWEciCd911o2ZlQkuSqYTKLInK7dEaObL9nJ/LAs1LLfgn5aHai4aqPTIiHm8mZcwHDbrotTed8od7Bi4ApJB8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD18ZlPdZeu/fSqQO2GVNXCL0F9aTyNHq5O59u2AHO0=;
 b=nKiw86ePNigp7Z1gg1uRbJr91K4WYVEcpgLjJ9875Iz4EQYW90Dyef85Rq2zBnlDQYBSBfne0At/AMVipc1cnm/SPwt1ymvt/nLv3plHFKcpbpqwlIZn5OHW3xXjwUcAjqP+kmfEOEfEk++na1vEMYhgLGqzumYY6IBFuMMOBdvhL2+XlpWsJYdSCTlnDmllEarxPd9HHKntIH7Il4W301MeyN4tYglrPrY+Alg1KpUtKjXPYuKQ++O8wsjAFxljXQME2OO670OVL//+20BsYTi0ZrvHsNsQA52Pzo53GkPsA86Evsuw/1PP6Mmr5cA55ZfgePuDlMNIuXxs1Jn2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD18ZlPdZeu/fSqQO2GVNXCL0F9aTyNHq5O59u2AHO0=;
 b=Bv/Oob4z2P0uTHgS32FzDdGq0jDsrt6ePiglu4a38O+/ER+W2WjlkNPlgKoEDgJUlUFpdvv+poDyuGRjOpr9tbqx848MoeMkBvUpWy8ka3Ey5IRGm6whXpG+99JEAh7r9PLm7MkjadSCdwSwumcsNTq3sBvcXEQS6UOtCEtu0F0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Fri, 20 Nov
 2020 01:45:51 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:45:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 17/34] bpf: refine memcg-based memory
 accounting for xskmap maps
Thread-Topic: [PATCH bpf-next v7 17/34] bpf: refine memcg-based memory
 accounting for xskmap maps
Thread-Index: AQHWvprOBxUHYPW2NkC5pM5cuZUzN6nQQIuA
Date:   Fri, 20 Nov 2020 01:45:51 +0000
Message-ID: <9F97F4F7-30B5-451A-9EA9-E3895EA75EE8@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-18-guro@fb.com>
In-Reply-To: <20201119173754.4125257-18-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9b9b3f9-313a-42c2-315c-08d88cf60338
x-ms-traffictypediagnostic: BYAPR15MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2838A57F29ACFBC9F6A2E986B3FF0@BYAPR15MB2838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UYiNlD5L5dOFy7ZDjNXNW8OK92zVz7PDEh1qvsvNnW6MgBJq695cKIxLF8FiKQ3zgSqxemLMERJh4MeKQNqxJXvfIXa2r9X/PqeVveDKiQaCIKzCIubFFnSdIcJHZM0HFQ6yMYjuHNrXIIXuQ2HR4HKJa74dLsUD8Rbu2DuUBen7Mg+LnWuN1hGf3dPzm+XfD9dEnU6Xyk+JzIXM00hR05Mpy7SOly8+kcE9Nro6Lgt1EDXrdURD4SYl7qIto0jeHnpVXQaqlJmwoLNn95SBVghiOuoTxVKg/pUdXbAUmCABHd3uM0ldLfKRGNnBIlRK+evVyDcAEv3Euw2/1EowEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(5660300002)(2616005)(66446008)(33656002)(6512007)(4326008)(54906003)(64756008)(6862004)(76116006)(66476007)(316002)(6506007)(8676002)(37006003)(66946007)(558084003)(91956017)(71200400001)(6486002)(186003)(53546011)(8936002)(2906002)(83380400001)(15650500001)(36756003)(6636002)(66556008)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eEwnBAXPzkMfXifDJwAmnsIKZg4FHeV/WThU5m72XOqt2VNW7wooKV/2Iqo2TFbVKnemh2X6GupD9KRlvkuTNYIBWDKDMw4q4RXKfWCU925M5eeV+tps90v2MckSMcuXO5vHTYsgjuALKcWmGTQhSeo1A/UHWZyD4cPRzZg2ii83/wH9esD9W+cLeZkQ9tYum2LGo+mdsTc1MkPRCS+22ZxKInGIw9drBjWWeWt6/kE4JjsXONPRn/RE8f83a9pPpAKxqu/bcz+xhVE6RY8WYezg/8kgSx6eijVzevqruD101bBD7nIg17KbN7AQ08v1BiOpkCHVG7CmTeB5/c1XqXEm2rvARHY6mU3OLfD1w/WblYEnnaCTdhOoPb4QsVfEABw4lf+xk55v8sPUxMDuc6PyRp3nZQ6UnpLaAax4zFrQpNIcaycvOPfMMe9cWkdu1GUeuwvHE7eB2HA1h7pCcA+IXxRb7M6vkC0YrqgOftXpKsVyxSzMzLI5SU/TknRFrRQpysaidqfiepq699adw4TFnbTQIaW/qMEhgdIAMuRDSPgNYQLGHXelCP0R/jMW6TD4U22eW43uSwBNRXS3nD6agziuzTOb+PN+w7ptw3w2aRahVvhxuHgwSmg7FTYY/SDPwLlANlqSRDowrzb09kRaN6QhXt45+uubjHxKlJNeLBj6CdrTdeUX9ng6DdWZ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB2D8F9314125B4FBA9B48BE1D8E2AF5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b9b3f9-313a-42c2-315c-08d88cf60338
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:45:51.5553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9fV8Gf8qDGsEgsUeoN1BDnUSfXBy5z3aj7BXB6o6npiRGBvd80ZfVKeHIZDM8V6EB8mtww4MBlIYBEmKdo8Jxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=847 malwarescore=0 adultscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Extend xskmap memory accounting to include the memory taken by
> the xsk_map_node structure.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


