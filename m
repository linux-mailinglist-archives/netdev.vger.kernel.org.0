Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F2324C33B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgHTQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:18:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729556AbgHTQQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:16:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KGEG0M012606;
        Thu, 20 Aug 2020 09:15:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=03Wmz0fHFL2RJ8jchaGBKo2DdkVJ5n9iybZTpBzGJtg=;
 b=Cf9kzHAO5exOcAlGbMbItfoMpsWaA3QPXPiBQQ84llRtL6RMFd7FfhpblT0Nzm8rVFkf
 CwykhjbwskSHTDQChXgI5VAPX0Fppgk4VDxrFA0t5ItLLr7LaahCSSbkQk2NtiC+zdGK
 Y8K4RCcwGGr3cIifYk39NSD/X+Uea3zkrnk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxy0rd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 09:15:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 09:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuCHi/qSf3BQOSnmQdEEsQoknlcMJoUp3SnP57zcylzjerXRj0iLUd8QkasW2QxD3alxbWHC3xv0wqiW6FgNHh/qSErMeuVgWXl9cFw3imhEUre4gJPmiTzvf64reUxG1bZTtDF7Ghrypihqqu84uRSPp0CASYjMZgbNyg2jJHh//tMBImy01EaYLteZhQeg0I52OymHu2S7xjI6NIvkLnyW96NQa41CrwqeVMlQyXMlpAPj+n3bV2zpsON+tjxglFdc+UYMGHYz9unv68IsGnjVqYbwXNaITrnEQtAztKKbA/ruXLOlGnq4MROj/kzsapCWYZ0Cwzyj6FWeI6z33A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Wmz0fHFL2RJ8jchaGBKo2DdkVJ5n9iybZTpBzGJtg=;
 b=QxoonKyUxKFWXv9i3lVWqbCJgyDyUEAt+YC1AUFijIzwCQrQzAvR12Di7LlrqVqClp6FqvpR9SiwI4oMorgWKAQXeFxQ+L/5IeaSOOmd6jmdn4U0N06JQQrOnokABUZfl1RWg1ybIEHIIwPo95zJCwy9zn7wgEnIuE0s1QBKzHwEhcI3YRtnYhbUfPNJk3RmON390cIxPCroRJYeKeHVG1WlsoqfyNOCVkXiuzAkeO1HxhJqJWI0u8cZ4dD/DN7aTHRG+VYbswjO8vqfZob+Cg/lCMl25nfw3sIsolBVsk5VYlsfZhCNqUvtps1EoHSTgCUBBEbIdi44zGoRvZDWFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Wmz0fHFL2RJ8jchaGBKo2DdkVJ5n9iybZTpBzGJtg=;
 b=L6LNzWoNUH3RsQolP1cv/OWH+javjYAjqbZ5+Jpns//o+Ip1IGsCUJ5LKIH8RA8nDRneATtp3D6yCwHFSRH7Kz2akeV2IvRukCxi3xSRWwKMlBsh5xcOY2pHTCnMFvLYbhkUk9ilOy6d3jpHYtAcGeMCwua+cywFsTnsoyx9/Fo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 20 Aug
 2020 16:15:35 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 16:15:34 +0000
Subject: Re: [PATCH bpf-next 1/3] bpf: implement link_query for bpf iterators
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200820001323.3740798-1-yhs@fb.com>
 <20200820001323.3740936-1-yhs@fb.com>
 <20200820080701.09f23759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3270dbc2-7f7d-b05c-7244-9fee18503a1f@fb.com>
Date:   Thu, 20 Aug 2020 09:15:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820080701.09f23759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:208:23b::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR11CA0020.namprd11.prod.outlook.com (2603:10b6:208:23b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 16:15:33 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1887f17c-e4fe-406d-65ab-08d8452444bf
X-MS-TrafficTypeDiagnostic: BYAPR15MB4088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408872009DAE8761071B0FC9D35A0@BYAPR15MB4088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOq+4M3HgD90+vb6vAQF0lYcwDtiSe0hjOoHuP7gMU50e4xsy4XFE1BeSk937H9h/FUWeGpL84dq17PjpDnQC+j9kpvDQyD2E00Ug41aBq9MKb4g4DwiQQUP6W2zRQlk7/Fq9ukDeYGBTGFPvwDBs2oLweJPo51NFTdlF8LeqdagPSedtbN7RW+dOdHksk4iTN7TtP0LP5na8eUIJU4u6MQ59KV8rz+CIY5P9twshseuhZnoirDCtIoMJ8E/Zv54QEOTWxd/30eTVmBTnRwKrQ5CcOHT79/Yin8frNL0x+ritXzrKywv0qrj6K+eUlT+YwsT99hXF/z+cZG9AoJcqrv7JX9nr1S4qER2wOZBZwc/jqjtP+CNyJs7xhY0NgTHTsO3k01LJv3Gg49/Z/mR8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(376002)(366004)(36756003)(110011004)(8676002)(956004)(478600001)(4744005)(86362001)(2906002)(2616005)(16576012)(31686004)(6916009)(4326008)(6486002)(8936002)(52116002)(54906003)(66946007)(316002)(66556008)(66476007)(83380400001)(5660300002)(186003)(53546011)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lbAidyrg7VZSTXSqo3eMK/50JYhURytipWe3nxpboLaPi4Q+W0q0/u43dOkbRvqyQd+Q462CnlPyfB7D1W+ihchML2GPrV0gz6BTs9I0C6ao8SW3y1t75JL3XNQvYEosuQb5Y6BCmHiRl+9B3PEmO6uep9TINSL1MH7BQfCkrvQG2loeFDdzhM3tfGW81NerVRtQ387bATh8yfdx/ip66W6FUssMTLYOK/SOoiqFAenp7oGX9MsufmNfhNNKYwjMKHYrERg6bKPGKYWN6Sw1cLt3DUhW483suhJnmHZcG6pilwd9RR0AHB75eh9lSm9fbFR6jnC0GnFsUACDG+7F3SA1lRsh0CafMQC9ADyxCcTyvts8Md+B9ZolYlrGKe5NTMoNfX4eVD69V/B0zdtZmt8umGg9aBcjKr/SRLbrlvQLnGsPYKpflhsmTGxjZUfoeEreFdzKwSUekXKgkTj6ShK4EIwaOSR3OZrS+Ij/78zLoCb4tkVQHOEYgV41Hd7gJmh7zSQZ7sXDl9URK5fibdd9ltedwnvV7AGL8gIUL0I1CQan/4N8JERLjSC/JxsVnhhzXH194BxOLSI43BQ022CGVg9Gf37pWn+IaVyIC6ZAlyalvs127Xvz5DBOTmH7GeQHRekjIHYPaRetc2eSKRlhS2wwYHYRIKcZr1MkZP74hTPAZHqU8s9Z8nAPIIoY
X-MS-Exchange-CrossTenant-Network-Message-Id: 1887f17c-e4fe-406d-65ab-08d8452444bf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 16:15:34.8168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJuFLH9KYNh4bPJ0KL5P/5orjg0wgnGcueHxhGr3eW4btXKQmJ7koZm0BD8GWCxI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=848 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 8:07 AM, Jakub Kicinski wrote:
> On Wed, 19 Aug 2020 17:13:23 -0700 Yonghong Song wrote:
>> +	fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
>> +	if (fill_link_info)
>> +		return fill_link_info(&iter_link->aux, info);
>> +
>> +        return 0;
> 
> ERROR: code indent should use tabs where possible
> #138: FILE: kernel/bpf/bpf_iter.c:433:
> +        return 0;$
> 
> WARNING: please, no spaces at the start of a line
> #138: FILE: kernel/bpf/bpf_iter.c:433:
> +        return 0;$


Thanks for reporting! Will wait a little bit for further
comments and send v2.
