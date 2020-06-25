Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5822099CB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 08:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390040AbgFYGWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 02:22:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgFYGWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 02:22:21 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05P6FGwQ011212;
        Wed, 24 Jun 2020 23:22:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RqrdcAjV8piMh7efwTNJ3YAj385hrSyDzyumCYpUo+w=;
 b=XbIDj3KlDOcE26ESMTHAaupmUDeBBxh3eMSOOxM2FM/tWEysL2sjthNsgFmoipWusChp
 JUq+vTJqo1cx9JPaMxjaO0XdXXEfUK5pdPe2KuoaLV9qWC7/dn4mn7ZPj9fxz2F9pTyl
 3Bes39SXB70C10aPQSEkRAn93cQNrV7ODOQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0vx7mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Jun 2020 23:22:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 23:22:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGD1LtQMYLP0P4rS4HdCntZM2R+V32leDh5CwelHlrTObtOqbewXRJN8qPTWhHQneqO21tbgjkzY9Ogk3T5E0UbHsRLhwI+g582mWqOhNPNeppQWmE7hGMl5otgB+y3rBpayO5UZMPMo9NCGrzGTxDjsk6KsLpc3/uESPwNVw2sdtQ4oEdKCo/aF3OLXY5UrpN/F7JJ2vOGpACxQpIpYj6W/VjpsTMD+hdM47ouDNc5pPa2Lt7ApYUfnPPf/fLZ9fy+0+hV1j09QLpbhcRoti0kjXsL/nGjKYP2vTaA5+UKan6NhpGMtP5Q6eCw84ta3aZLovxfQMN07O2XzBBmZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqrdcAjV8piMh7efwTNJ3YAj385hrSyDzyumCYpUo+w=;
 b=Vx0AuYC+lTt9aN3UQdO1wQ+17XMPp3waNoUvESLw58LCMfYJ6UtpzOxhTCRmry2Nyuxp0drZKZt+6Ccq/F/tduOZm34U5HuzAnaot7dRSH98YwI0da0tOPKuZw73u0HAb6USRfas8WzjNUVa5mcgPsXOt8QKdtI/L5wfUd30s2HkxR1XZjgFaew/aESVnW3BFwMXEldDN+Di33FitFhw8Lb+r2yznAJIcekcivzc7uYpBsAL/Vwv6u5ClV20/R0xTUahWYxMyR2jGuX0vvlWn3nfuIQonRKtd2sxeANRf6ujnb3qQaL+S1o+03TT9WiGav61EVX5Kafej2GNL6Wc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqrdcAjV8piMh7efwTNJ3YAj385hrSyDzyumCYpUo+w=;
 b=jk8GmeS4/8CgZYUzUOHDSzUAXGFlEaAoELn9lIHYVF3ak9d67hiOHgEbBoK/p36f+aRnL5Uf6Kc5Cb8I01ZoDUMVU6dxQsiNfAStLMXkvMardbPUZ/tjtjabZXJXOxe9wLY2TAryObuz6tKr5huKvsw6aP3w0Q4MM6eZCPhC3Zk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB3738.namprd15.prod.outlook.com (2603:10b6:5:1fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 06:22:05 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Thu, 25 Jun 2020
 06:22:05 +0000
Date:   Wed, 24 Jun 2020 23:22:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH] bpf, sockmap: RCU splat with TLS redirect and
 strparser
Message-ID: <20200625062202.jyt5dzcdbanwkah2@kafai-mbp.dhcp.thefacebook.com>
References: <159303296342.360.5487181450879978407.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159303296342.360.5487181450879978407.stgit@john-XPS-13-9370>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:180::18) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:24c0) by BY5PR13CA0005.namprd13.prod.outlook.com (2603:10b6:a03:180::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Thu, 25 Jun 2020 06:22:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:24c0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62e23594-75f9-4fc6-a28e-08d818d01461
X-MS-TrafficTypeDiagnostic: DM6PR15MB3738:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3738B4FA9FB64C06186FC417D5920@DM6PR15MB3738.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ov6bZ0MyEWnYq8HIRcah1arAKwhdGfeMIN74TQwNBlml0tSzhNfDPxAK1TyiY6K0qJpeVt3ZUPM1CZqnYHRp5hNj6vYBenTP5CZvZP1+b1u3Ep7UM91OLwXcnZZ67X1G3sik2C50KGGWau4bRDe/mirQI9ZLbE4+lEeMNX7GHJeOXqTgOhHuTZ4PDBoKXqq0CCUZRo/p27T/F9RbOTrZahYZ/h9yvjoK/YAzVO/NzLuP4xwZedwgrBSv3U36CmZMzWsdcB2BRaN0f7fIMr2Im6p89BzfTkrDW0kvrTr+zb8nl+qudzeegBRGf5l8GdnK1DquKycCIyira+dZDbZxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(396003)(376002)(136003)(346002)(66946007)(4744005)(4326008)(66476007)(5660300002)(6916009)(8936002)(478600001)(66556008)(86362001)(8676002)(83380400001)(6506007)(7696005)(16526019)(1076003)(52116002)(55016002)(316002)(2906002)(9686003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TQk25Cn8bhHGn3/S/ZuwEZKU7gOSbjHa+ANT0M6gj3zvNq6ZPuOlXOduoI9Uslf64413GR/gJB4cUwQnBHPjE6WW6YuPCsu7E9XL1uK7EGZO8yu38ky9MRfC1u7oLhsTbV2QdawsDd4AG5EtKXsoYP2VciSQ+Bx8VBG75YHuGx+VcoVmRGG6X5SPHS7UTxBrJd0ja6Dcj88LRzJNY/p6/KJBw6k7sl9P4aBlxa/cKv3On/aFtsXm7oUP5ZPmKzWLxKuw5jqKNJmW7ZtdnFxVrK7rLt+oejpGalpCinbqD/6YyV5iT7SHfwqq15WmgbVnuIITVgFG3JYJNeOcXopPBZcUl/QMJvr4uC37AWrWi6hyOzrhz4l9W6+HyeSQfODe9ifiFz2CCJhwTLuZhFL37VM+4Q81AWpzBfXb7bRBS2TFg82HagD4zSgthDmy0e5yNTWhXuuhAqaT3PUUd7/a6Sdw6vJUsC2vAs5crmikDxqKifRWwS4Ko1M4V7vlCiJq4qvNQD2Pl2vLlhflBoYlPA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e23594-75f9-4fc6-a28e-08d818d01461
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 06:22:04.9610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySxcTDPeiuTHJcos/XWcBEETNs1x+JB8exz0zPz1KjcqNcGhGnguBOelNNaH5A/C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3738
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_02:2020-06-24,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 cotscore=-2147483648 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=824 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 02:09:23PM -0700, John Fastabend wrote:
> Redirect on non-TLS sockmap side has RCU lock held from sockmap code
> path but when called from TLS this is no longer true. The RCU section
> is needed because we use rcu dereference to fetch the psock of the
> socket we are redirecting to.
sk_psock_verdict_apply() is also called by sk_psock_strp_read() after
rcu_read_unlock().  This issue should not be limited to tls?
