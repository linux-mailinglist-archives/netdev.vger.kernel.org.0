Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5496183A8B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCLUZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:25:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35756 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgCLUZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 16:25:31 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CKNTmd029007;
        Thu, 12 Mar 2020 13:25:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2JMQcd+BeNXUZyWrUz/8Wgmc2PotJWWQAkDmSpMvXig=;
 b=D9us3vsVmqVNgkWQcq2+qin0snvV8/OBUNWDEK0mrGiaK6+azUEmu+6sXValy63KtUON
 5spR46SwVy4VpQYwtXkXnaOJSO5g5OoGkPUoM9CQkybpSUrO+arD+OmNk4nzyv7SXgpD
 PhhjuTlTOUrVMSmT2xuR+0JcB529Jdftx/o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt96rkgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Mar 2020 13:25:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 13:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcx6lFE80OAXKGOk8mXo5NhgkGCxJo7V+E6Ot4Bz4F3tHYjJkalQyAZP1OtryUuRUqpXHTWqodM3TdctLlNuf8Nb+4aLz06s9fEYkvOe2TmF99vZT0gzauVVf0yG0Y5ltHCKC4qZh3bdg/0Sl9yPGyeifTQZPxbdRUpxeTysAnfCAYwqjNoa+GIa/lwJW53XyKECzE6zaBWYRB5BUsXT5cVulRO/3WcoWu4rZGpc1PfMYzPx9tsqMYOks+PbDl8mO0KCdAxdW/IKDj88VJycjzZB7FYLYfouCYJpqTPWXcihJYV/c1VSNpEMcd59KfQtJgYSN3gUfmeyUdpm5zbX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JMQcd+BeNXUZyWrUz/8Wgmc2PotJWWQAkDmSpMvXig=;
 b=JrbhZJXHqGWxnMtbK5biGGJjjx9gePsvbpw7sZOM6G/c+p4Ol4ygLKhqPs4AKbYGHRr/z3Z0w9Nl8l8Ac6QsHQoJnvCICgrZ5z+sR0aNo8BlKYmz6BK81vh4FKcQ7hfLU40xh7XktEGvrct23oKTk+oxbe51AybXBjiO7ThZ+S2JzKurMYO91bz5vHBMv515x+xSFMagYU8+dg7ujl/Mh0H2UTJzJYb4QJAhLqD7krB3ZlEzfFSxsZH22pLwVMlMAVkc8sFLmL219tcGukJWE/Y27ZNFifqcls+8sP44DSo7ovWHFZ6DkDyBDrO4hTtLMOb1uvk6NodiWGUVad2jHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JMQcd+BeNXUZyWrUz/8Wgmc2PotJWWQAkDmSpMvXig=;
 b=TFSHmNPZ3VLFmH0elvCDdU/bmx9b2UXQvh+pZGbbENyVKQRIHSBpjZKMj1DNwjmOQ8hvwPkvfkLk7BWZ/AoX3Db94cwPVgr5ycNz556fYEC6jmfy4thwsAIvm2VkQuDoDdugtb/qDgiFgKsBAjQQyWk6J2HisPaAZr+B3QWTC0U=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB4133.namprd15.prod.outlook.com (2603:10b6:a03:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15; Thu, 12 Mar
 2020 20:25:14 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 20:25:14 +0000
Date:   Thu, 12 Mar 2020 13:25:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/2] tools: bpftool: fix object pinning and
 bash
Message-ID: <20200312202512.yuiesbhlrsglziap@kafai-mbp>
References: <20200312184608.12050-1-quentin@isovalent.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312184608.12050-1-quentin@isovalent.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:300:129::16) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fd85) by MWHPR21CA0030.namprd21.prod.outlook.com (2603:10b6:300:129::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.4 via Frontend Transport; Thu, 12 Mar 2020 20:25:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:fd85]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d08e5fa-1bfe-470a-1c5f-08d7c6c378d6
X-MS-TrafficTypeDiagnostic: BYAPR15MB4133:
X-Microsoft-Antispam-PRVS: <BYAPR15MB413309D6C88E7AD703A40D5BD5FD0@BYAPR15MB4133.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(2906002)(86362001)(316002)(6496006)(9686003)(186003)(5660300002)(52116002)(478600001)(8936002)(16526019)(55016002)(66556008)(66476007)(66946007)(81156014)(6916009)(81166006)(33716001)(54906003)(4744005)(3716004)(8676002)(1076003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB4133;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tb6rqKeag/pEWAG+ssrimIwXUA6BlgZaczbBHMSAeE43hUbYCiE6OYqQdHygVgDc9elDB6hgZ6iVGVnpTYznvRRJYUnTdgLGPpgluitqH4Qm8syq3Mu9ZbaDh9qSt0EHuqqPaE9ALdK8hLT2T0gql1lFu8rVHtjTqLYRWcZ/2vO1bFehAmXx4aTbtMLz4LVbtmJmOIcsMRLD2jajKY3fKy5o5i6W6auYMvr+HQTZE6GI9ZHN7IjULF+zliGfRbZJKqvdnuBSS/cTGS3vMND4H3fTn2l0IwxUlMT6CxgnE1WZe2PWRgSbeuOV+rE6B6t9722TivDZmT1Jgr93jB84fQ37yodJYQHgeaafk4VeeHnP2Y4B/cGyxGd2EAlRIypyiJx0MGowMLicE8mngfR3JLp4FyHr59GTzvyq5xuuAFP1GJWZ3cUGC1ciahx+EeBu
X-MS-Exchange-AntiSpam-MessageData: n1zaxyr21vQUESvsS49kQt96evAxdwoogJhWtZ4MnU9oFXs3CASCZt5joZXxwKkhD2uZ6nBM0Cw42jQrlfTaPo6wWMPS1+JBZxHnESLttAjHHiuU7ipgovISmF8mrm3Bj+fnnlxvu/4HxaPDTPd5mVvorkG5kB2Kf02gIc9S/8akyrvpqmYBc0dqRlA0IOOn
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d08e5fa-1bfe-470a-1c5f-08d7c6c378d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 20:25:14.6633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rGV8Ur5SUUmZP7VzWd2XduG/cggKT8nUDJX/JwJlkbgAvtkYRbd89fPIgXB91ap
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4133
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_14:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=595 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120102
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 06:46:06PM +0000, Quentin Monnet wrote:
> The first patch of this series improves user experience by allowing to pass
> all kinds of handles for programs and maps (id, tag, name, pinned path)
> instead of simply ids when pinning them with "bpftool (prog|map) pin".
> 
> The second patch improves or fix bash completion, including for object
> pinning.
> 
> v2: Restore close() on file descriptor after pinning the object.
Acked-by: Martin KaFai Lau <kafai@fb.com>
