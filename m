Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE5017EC90
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCIXSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:18:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2856 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbgCIXSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 19:18:44 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029NHP7a002081;
        Mon, 9 Mar 2020 16:18:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bzxmk7s6gkJQRnhHOZREPfVShXOXRP/KYzvWD5UKIf4=;
 b=EGB8jwCcMbAbefHvpNiNGx5p/uqFNVWI8HzENlXzHtNaAD4S+81hENtLAtQ0nsb2vqNK
 siqW5FR46HmLTILildGulZpt/2BkQbXMYn6M6ViF0TtQ35lmtpUg25yCT8ELaR2lPoS5
 qvNtdPrZqBmwnfkJaS8uQiOB33cnpbSrjt4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv6jqchq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Mar 2020 16:18:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 16:18:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRaaGJYfIeJ1RTwgWxPAmj5exLkxcmZSRNvUaKPJ71CLUrA/pPP4hjsfAkkhgIppZ4I+jp3hMHWh3IwVrKZfv8pX25HZB4GvL5nDU+yU0YuoD/mrRMb65YZxMegp1hSPEiFRCClu3P2rDZHNncZtbf5NQlcyWgWQZ8miON6nd6Bsj71bwiT/3eOqYPvlv+vjSz+VZRDzl2jQ0OP1482QcvfRBjlH4qV71mS2Ja5vd9AvKNxLRpktADmZUvLfe3TRlunEl0Y83RkAlhM0/eK0YeVkcYdw0k75Z49QDwYeGAV0S/9/ORZexdnLCxKzk38xAwKzwhZEeKEnUWl8mgiI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzxmk7s6gkJQRnhHOZREPfVShXOXRP/KYzvWD5UKIf4=;
 b=Zctyai7x/C9JEz6IXOyk32efY6Oz02LA6MKLBxOTh/5YuUnxdjstxfRqIlpxnBRlKvzJAj8sfr0K2ghqZ0tTvl7Exz6ZeiVztQ8s/m41MHoAggC+5JwOtHUz/Mu7cREz3nHPe0F9j29kVoJbrkLklgBzloh9tBEHg6HLtCOeWFfWRlgaFRFVtdASIf9ETEVrELK1AbuTGxUOnvN89/o4b5gqyuLOWNUG+2Tzy8JsgUbENzdhU1fdZamHm110GNn2uYZt5Oe5DwItmacVF9EvDv7b/+Z2dXaPwALnMUYE0hmUkCYQMKsh71hoNGh0qy1y29LxiWa7I2Rd7BaDsJfsVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzxmk7s6gkJQRnhHOZREPfVShXOXRP/KYzvWD5UKIf4=;
 b=IR6t+csA9abovX29CooAqXkRtIwARkkPw/ie2tftXLX6N2pIEGwSaud7dhh4uiHG1GMqEA1Ij6MzXvE2oVr7WDwRCbeaBoqzQlwOX9cD51/V59D1sOhiaBYzWGLiSc0aRXBAWuSFa4oxoerwVYQpmeRDzO+zRJa4iU0LHIF3Fn0=
Received: from MWHPR15MB1661.namprd15.prod.outlook.com (2603:10b6:300:124::23)
 by MWHPR15MB1502.namprd15.prod.outlook.com (2603:10b6:300:bf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Mon, 9 Mar
 2020 23:18:28 +0000
Received: from MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::f930:6bf2:6d2:93ef]) by MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::f930:6bf2:6d2:93ef%8]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 23:18:28 +0000
Date:   Mon, 9 Mar 2020 16:18:24 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: fix cgroup ref leak in cgroup_bpf_inherit on
 out-of-memory
Message-ID: <20200309231824.GA66037@carbon.DHCP.thefacebook.com>
References: <20200309224017.1063297-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309224017.1063297-1-andriin@fb.com>
X-ClientProxiedBy: CO1PR15CA0081.namprd15.prod.outlook.com
 (2603:10b6:101:20::25) To MWHPR15MB1661.namprd15.prod.outlook.com
 (2603:10b6:300:124::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:6053) by CO1PR15CA0081.namprd15.prod.outlook.com (2603:10b6:101:20::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 23:18:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:6053]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13b315a7-6871-4f4e-f339-08d7c4802c82
X-MS-TrafficTypeDiagnostic: MWHPR15MB1502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR15MB1502B58AB0DFB8149A1F06F8BEFE0@MWHPR15MB1502.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(39860400002)(366004)(346002)(199004)(189003)(4326008)(5660300002)(1076003)(4744005)(186003)(81166006)(33656002)(478600001)(86362001)(16526019)(8676002)(81156014)(6862004)(6666004)(8936002)(6636002)(66556008)(55016002)(9686003)(2906002)(316002)(6506007)(66476007)(7696005)(66946007)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1502;H:MWHPR15MB1661.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qfx7MkneoliKZKHFK7LzfBY1yRCkWgUfONaqWpL+k9P/p5RbdaeAPeQRtZbeGJZ2NlHJYMrpy+bk2x5fzVl4KiPZT67WKiy1WEfirxf1+KTatXuwHOxsGplHGaC5uv5BQnuiBCtQHF9PTZ0VXAVJzGzl9l3CJTGyPmu3e6qQvZMoU/+0Cs0xXQhG9gAzEJlMyUPe5/PsQ/0C0ZG5RwdFkwinjlyxPPMhm23WrC/UgeHTSEY8qDoid0rJAU0vwMRT+aoB8A2Z+v3OX3PckjSqsmHuEwv5jGPZpkNInG67mtidHu/UTL+ZXwUm64C3mu1+gGcq9HBCUmdjWYYISYwX8XxKdXG0imN2kcNtctg0vHdQzaluJEbkWFq3JkJamK8adh1IIH7R5XTT34X4Lw36IpXEoaP+gPR96jDjXMRNaEYW0TFCqy4HJusvaHzQVsBn
X-MS-Exchange-AntiSpam-MessageData: NFmDidzVAyJBU9UiR8SnZnZfV5hg19zlOMznxgJu5bMz3/3YSEnnFPVDfrrSn9I9gHAphhaR9z8D9gn1icmJGbaTWfiksUnBN0blfnKr86bgMrocJlD4OThJFdI5P0bvEJVg8Ge9WZUub8OQUf3Nlf8tyhEikFvqLnF94wRMJrLNvGrFvxCjlVJR3fP0hK8s
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b315a7-6871-4f4e-f339-08d7c4802c82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 23:18:28.1160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0unv4iCMuFw9wwbcF4GJtJpwO0JS9FQFMNmi68ge7P53JKAXGiblbiR+qt6H48x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1502
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_12:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=1 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=733 mlxscore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 03:40:17PM -0700, Andrii Nakryiko wrote:
> There is no compensating cgroup_bpf_put() for each ancestor cgroup in
> cgroup_bpf_inherit(). If compute_effective_progs returns error, those cgroups
> won't be freed ever. Fix it by putting them in cleanup code path.
> 
> Fixes: e10360f815ca ("bpf: cgroup: prevent out-of-order release of cgroup bpf")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks, Andrii!
