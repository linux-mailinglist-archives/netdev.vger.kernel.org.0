Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485462AC84F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgKIW0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:26:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729247AbgKIW0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:26:08 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9MAlE7006673;
        Mon, 9 Nov 2020 14:25:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9eaJlCFC6gkqbyH5Q9DlrZgYLwhIFKnPMojnJnvzeXs=;
 b=qHo6tTBslrtmpooLuEkpHH1xgSlujH59sXT/vcB1JazgvIEDECNCZe5FRPh7P2dw4epJ
 lPJVJDO284S0UKYa5oTpQPrdfD/J+nbq9Bz5IDqvWn3XM5CedaYiOgmYU2MFL+Xhmebz
 qOFvyWF39lAVz5yWDUe+9ZDGoWyrgkoKqDE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pch9q7yt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Nov 2020 14:25:52 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 9 Nov 2020 14:25:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koaHLv3w4EkZSyqbDmD60QZnYBIzDWsaUQvAnJEmhDRidcMlQlmRd3lYFNW3y6qfEX9xTSlZrv0QijYFDTkjgwtnxHClpG6/MEkKZ08wz6YlWHSZcWSsSdOriogQep0VHu77AfYK1dSJVx3Cth1C0n0OlduDNntlUo0KTQFYyPeZ0VrJs/g/aexRL9W2gSWZnZpcFWfhwEsMLsh1jbIaeUIowni/XPH4AnpNgwZX6hlijodsCY/2dse73sfKAtNL93eNblG5DEJVcJcQSk0qkSLF4cA2cPITO8yS/Nym4lEXyjz5+AQFC1TzjQcVWkYvbtyVegdpr+66vik8lMLE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eaJlCFC6gkqbyH5Q9DlrZgYLwhIFKnPMojnJnvzeXs=;
 b=oZ6BmWLavi5iHfjTFlacgiyrXDIebPXimF9oWi0PWG8ZSTh934Xxkz7UYC2C7wAe0WjpevYyorVFC+NI5qp/dJ5ykFkGLVovjTiKMcRpMkaQFN8ApWdr7xqmG9NBlZD+0Z4kPygjaecuyzMWunACMu7Ql8gYOSXtzmeOGzsdYElxNNOFHtuyj2Xno2RQgA7E0XFJBrmtvXAqyI0aPCwbx+xmKFpgoh2PdtKIUC42Fp9UHWIyok0sAqHg/wzSuBybuYDed8JYL7ER5+2PCy/fPz6NJN1I0qzdqpa3KPVB+s5liUBUdLLZafSf0yKaL5RJcFZvLh4dBhW6cUPzAs5T5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eaJlCFC6gkqbyH5Q9DlrZgYLwhIFKnPMojnJnvzeXs=;
 b=VJk8QXs7Eaiob+1EC3TgYdOYjX0+AEyMxpwp/zqpleiF6r3n/22JS13YVmTlBXVEua4lr2Joba+JIqtpQBVf4Kr574+2aYveg6O3MNfE06XHC0ziSagOD8amf0Pp0zO0zjbpEyq+frtsTAZcZGe40F8Mcig4ODHFT4LQ5Ad288I=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 9 Nov
 2020 22:25:42 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 22:25:42 +0000
Date:   Mon, 9 Nov 2020 14:25:35 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Subject: Re: [PATCHv2 net 1/2] selftest/bpf: add missed ip6ip6 test back
Message-ID: <20201109222347.kxe2nkbkzalvzr6l@kafai-mbp.dhcp.thefacebook.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201106090117.3755588-2-liuhangbin@gmail.com>
 <20201107021544.tajvaxcxnc3pmppe@kafai-mbp.dhcp.thefacebook.com>
 <20201109030015.GW2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109030015.GW2531@dhcp-12-153.nay.redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: MWHPR21CA0056.namprd21.prod.outlook.com
 (2603:10b6:300:db::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by MWHPR21CA0056.namprd21.prod.outlook.com (2603:10b6:300:db::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.6 via Frontend Transport; Mon, 9 Nov 2020 22:25:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a17e97-953d-44cb-3b3d-08d884fe64a5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25840D7F21F43DBA0A9A6950D5EA0@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/OBFMfuUWKhb1vAp4Ynbxnef19RhO2OCkkqVzpNrhIOfg9Aip2c6dhJChn/52lCjC/Zj88YOYNqoWCxQWlOWZBYYXDJpHuvHU9mCm15woGRwOU+8O+Od9sObNLq4wDQveK0+aOstHSgba130fUbVcgYMtrnIHpQ4lmjmQprXB+DMCeAmfPMlmG0DtF0tEJfV6avxTxz5GBNt4mgFkL94hfFhkUj8I13//tlBAlJrSlLO+Ij+MNOaxcoTkKvI5jgyOyuwpKEvsbKCCWrBcp+LJYkEni4ESKTyisIhmtzn15oz696U4k6/BYeE8lPBCvRhWy1t1iNPeMsIaqw6iZZcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(366004)(136003)(54906003)(55016002)(7696005)(186003)(478600001)(9686003)(52116002)(16526019)(4744005)(2906002)(1076003)(66946007)(6506007)(4326008)(6666004)(8936002)(66556008)(66476007)(6916009)(8676002)(5660300002)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /eMvRk9hF0Lh01fnlgIIvUny23dIlhW6uL9hRN+N3EejXTqtU16lxRZFP6OeT2sySiz4YuB8y6yZJLuEfAtogdS7xYIHaFeZu4qhpdGRAsYPn8WGkLvbyIc8alYQc7xHhDlXbWk+RHu+jXyZfBz2k261PPaAj7mp78ao0SFspzU/wNadjKbA6UvBORua/wFIuswupx7Gboki95cwVX+MLpx7DNSOUH4lxTJscObRGkTq6gVWyNW3qC4UmdYqO0CATC4Ldiy1t+1Q2dOgEF6mLBNiUfpp7YqkpkjV4enl5rM9V3K3tpsBNiiUGN2igvemdAPEBGmY/r9GzvxEzga8Ag/BF9qkUglq2M+biC+34+EhN/g64hXGepprolWPb1ZDY8QZcA8s57iv0R+6IaUk/FpFe8RTIksb+GeU5mV1RifT3zxgrzj74i07xEbfrRq8W40gmGA5uPrYJPu32haY7f4Okn0MMAEJx0gjldemgnev9gC6y5nJ+E2yacsOn2g3GkuMFGGXiubiQIsdxoFhkKXptbUCTUJ2A4B0Ho1GSO9pwAJU97W4h/Vi7rfACvve6f9queOrO+vl51CrDHNg/OC+qAadcCILIw8Tw9nxki1Q4Cy4AzINPeya+BEA47MJX7u90H1id/t1ip2AHMCXI6w58OyxWM68TmM+vKeSbJXxRncgs/+4BhZUfHue1IlOjnieHZB0OcMsG5xsqqJoRKexoKHJTdSmvdK9+TAIIwzSnYQjBSQnSfMoC0pfifavXBvFy9zKce540wd5oXzQxfBZ+T/c6lm35uljxcHc9cN+pC7/xXxNvdk9UhU9k/Ptp+E0VamTawoNir8uzEjkwvDd3iwp16AY8rD/Hum7yla5kZ01PGPEPN0no67EAngWHHZKhfU6dL9Ze0b1+QDLanChmznWZV/T+kUATCUoPug=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a17e97-953d-44cb-3b3d-08d884fe64a5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:25:42.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+rNUozVrrHgKu7HStNtCrJr/j/6jZTbZTSYCnHaZL9IXdFsVFI837C0OzXjq+GH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_14:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=1 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 11:00:15AM +0800, Hangbin Liu wrote:
> On Fri, Nov 06, 2020 at 06:15:44PM -0800, Martin KaFai Lau wrote:
> > > -	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
> > Same here. Can this check be kept?
> 
> Hi Martin,
> 
> I'm OK to keep the checking, then what about _ipip6_set_tunnel()? It also
> doesn't have the ICMP checking.
It should.  Otherwise, what is the point on testing
"data + sizeof(*iph) > data_end" without checking anything from iph?
