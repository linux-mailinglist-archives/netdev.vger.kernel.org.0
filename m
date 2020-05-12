Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20C21CF6F2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgELOWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:22:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30980 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728085AbgELOWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:22:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CEL3P7010641;
        Tue, 12 May 2020 07:22:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=C1DtQuq6JdEGN9hVfej9taEE8Nk3giWvwmOGXHJComU=;
 b=hg8xFxzf0ngMYauMDvCwFAVSZeq3OQvP4khpiw2TRJcHFrU3JbjhQnLCKa/HY0qUjcKV
 8/l7OhUFm47y7nd+xgH/H4VkezPEkXL9Hek6qe8NOEHtlFRo4ImNZ460EBkxU5f/i0TF
 Zr8EJOgNeafacOK1/lpoDRF+v/EyoUKFjVE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt8t7y1c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 07:22:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 07:22:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4J7I3fy/S8vTiZHiFuUXjedpe9O1lfrTddmY9Ug/gR1jACDM3EKOb3cMYzD2Dz3c+oSVXdQQ8excJom0vv8UjobGfGW7aIPdSfw9CU3sJyKA+QqjE3ViqgbUhvwHhC/eJY15FluKYyNiuSe4Ju0K3HCs8MB9Qw3wlRC7XfnrZtJ59K9jP3/B909oHRaCXGgeg3Z7lIvlvqfclDX9dXxsFQD1ib1Rez3PMzsVkpl4K42lbb5p+FZTTmfOlfE8TkW2LeE20ioypYNw+KUUQ9aWInt6kKn3fKMugMW5mVIud8qLryj+serHOeEu4gw8SQqJEQi3Cd0d1EuGEEtyKPC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1DtQuq6JdEGN9hVfej9taEE8Nk3giWvwmOGXHJComU=;
 b=fAHdj+I7lbuhrxLC5OBzgpkUwgPazBhz/lysM9+MLjpz/5RSGIetpRh7GYgjr8j02Sxgz3QhCh++QVcxTUPUBNAs0qNpzIo7oupy9W3SuVNNImw3J0/JDQ9DsY+DazOaxidViY17BBJpnWckljnZ4iDXV2IcAJBUMOQtVlUwACLNnxMwIX0WoePBFY2UKfUzEuu30hX6GoRvZI3Ie3GtcqoVAMtSe0ejtRBwAA0St23v28tbbt2zmV0tPVYsUCtz23Ducc7f34s9q/7nFOmx9tjKmWXrHUgAVjcFKuFxGXbljyY4BV/AOKvKQNTGh5RBQ8Ea0GB+gVTYfSysnIozDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1DtQuq6JdEGN9hVfej9taEE8Nk3giWvwmOGXHJComU=;
 b=dDXDiMRPFV4Ih+Hhd08oBo1RSHdegCR5M+tW2ZT1urLOPLVIheu/xkROcq3XG7W4rxpmrUX8E8n3ZvE6buxfkLhLLYvByq4hLNdoC7AHgg8rcAZaKmfK83oGQF1xef4xF2/oR4n/ykTI5QQrUeOPtJuB/LcgZuMGsMQ7AClIceM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2360.namprd15.prod.outlook.com (2603:10b6:a02:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 12 May
 2020 14:22:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:22:15 +0000
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: set MAX_CPUS
 according to NR_CPUS
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <davem@davemloft.net>, <brouer@redhat.com>, <daniel@iogearbox.net>,
        <lorenzo.bianconi@redhat.com>
References: <79b8dd36280e5629a5e64b89528f9d523cb7262b.1589227441.git.lorenzo@kernel.org>
 <c3fa2001-ef77-46c4-c0de-3335e7934db9@fb.com>
 <20200512105109.GA79080@localhost.localdomain>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <37d3d131-5443-291d-ee0d-c62cd136fc8a@fb.com>
Date:   Tue, 12 May 2020 07:22:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512105109.GA79080@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0042.namprd17.prod.outlook.com
 (2603:10b6:a03:167::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:d0f0) by BY5PR17CA0042.namprd17.prod.outlook.com (2603:10b6:a03:167::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 14:22:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18fb1299-2883-4b28-78bd-08d7f67fde92
X-MS-TrafficTypeDiagnostic: BYAPR15MB2360:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2360858B6675A87D35B99CF4D3BE0@BYAPR15MB2360.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJfYOzaO2nki5GuqMh+hVHvgylqHs4pLvrAWr9M8sLGZCHjApYqUfuBH1GwBq3CT3Nujzi2x4qB57/hhV8wygUy1/GFRjX58/e3qNMVASaNb4nMsU6eSIoR7bQ4rG/GoFNTsQ8+9kMQEnfG2ODDdEYWxr+c5jYd3hY4dhBqScku9AacokpcdATIXU5VGw4Vfa/LwbNjj06o6N7OuHKKqAilMtE9HErQscw6l/jnlBh3SXN4mnR1TxCK+/+B5SIBVJ8dNLwWkcL6BuDPR0H8kvSOB71YTHmVEhLpTw7fT63sdsEGF7UlqwGvCQ936DDV7ZfxJi3LX6kwYAmdlFDOLeIOxiEX4xPrFqo63Em6XkPz1VqFopj41Bit0FntEwnSLeIz1YD9rcyAlBzKBrdddXNvfd5VMJRIUgCIjj9fw7ERHxfMtgCA9jhc8no34WfYunV0VhSV2czWPznh5KiO8TcO8dwGugN8+2cNfz1kdtZyj7+Xd39I+GQSIgrRbKZ8cQ26gVd7hoKyWDDDtAVALbJqvVJpIPfyCbIb/yn1ZuML92ereLP/ThqFPWBngaKhB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(33430700001)(33440700001)(53546011)(6506007)(6486002)(16526019)(186003)(5660300002)(316002)(6916009)(2616005)(52116002)(36756003)(31686004)(6512007)(478600001)(2906002)(4326008)(86362001)(8676002)(66556008)(8936002)(66476007)(31696002)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Qf3TkJhX1yFODmDcEuOBrIkSzlwBfP3PzHASlIVOG/p2XLERPPN//FDtrIQUGa1LZ/VegCPtHfZmQs2lb7zEY7tQeMW5Q4HN9uAzGUt6Qw2OXXWYTFNdfcqbASP9XzF2w3RRDQwFHgZxIEVOPhInkONb92nefX0V5PTU1xbRs4+dDHgOvXEggoQfk+Wv9JRPKVVtbJlrm39qtfnFjiM8rTL9pOKEdo4wAobei1jzfO6fBkVtBp/n1n1JkIz5PfYTw+BTq3gk5JUJVhoopXC0fMvIMFD7Sz9XB5V2booQ2THXAhROTE+AcUblMRqVLHFxbp5C4Kt+SiBwgiK/+2sskP4lN5FvO6z3y8yNOcFdsDU+NgjEJhfzgaU2pfGzpDAuI4yTwbQPYiFED3v4FVCt7caoWM1qLokTqsOyQInjslCgIIMupqT6UnE6J/lxae6+DmPva3cH/TCcfK89WwB9ZVtkr17V/v2MNMHiTrfjnEhphdTIGI2yguWGeyPquL0NRzFbai8ne/Y6EmjfUYm2ww==
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fb1299-2883-4b28-78bd-08d7f67fde92
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:22:15.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1Q5i3LqcDNdHy/HAMlTIkmpSj/TdCe4bmcOlsADlYXeG8CnwzhcNzWSytL89Yct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005120108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 3:51 AM, Lorenzo Bianconi wrote:
>>
>>
>> On 5/11/20 1:24 PM, Lorenzo Bianconi wrote:
>>> xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
>>> allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
>>> cpu_map_alloc() requires max_entries to be less than NR_CPUS.
>>> Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
>>> and get currently running cpus in xdp_redirect_cpu_user.c
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    samples/bpf/xdp_redirect_cpu_kern.c |  2 +-
>>>    samples/bpf/xdp_redirect_cpu_user.c | 29 ++++++++++++++++-------------
>>>    2 files changed, 17 insertions(+), 14 deletions(-)
>>>
> 
> [...]
> 
>>>    static void mark_cpus_unavailable(void)
>>>    {
>>> -	__u32 invalid_cpu = MAX_CPUS;
>>> +	__u32 invalid_cpu = n_cpus;
>>>    	int ret, i;
>>> -	for (i = 0; i < MAX_CPUS; i++) {
>>> +	for (i = 0; i < n_cpus; i++) {
>>>    		ret = bpf_map_update_elem(cpus_available_map_fd, &i,
>>>    					  &invalid_cpu, 0);
>>>    		if (ret) {
>>> @@ -688,6 +689,8 @@ int main(int argc, char **argv)
>>>    	int prog_fd;
>>>    	__u32 qsize;
>>> +	n_cpus = get_nprocs();
>>
>> get_nprocs() gets the number of available cpus, not including offline cpus.
>> But gaps may exist in cpus, e.g., get_nprocs() returns 4, and cpus are
>> 0-1,4-5. map updates will miss cpus 4-5. And in this situation,
>> map_update will fail on offline cpus.
>>
>> This sample test does not need to deal with complication of
>> cpu offlining, I think. Maybe we can get
>> 	n_cpus = get_nprocs();
>> 	n_cpus_conf = get_nprocs_conf();
>> 	if (n_cpus != n_cpus_conf) {
>> 		/* message that some cpus are offline and not supported. */
>> 		return error
>> 	}
>>
> 
> Hi Yonghong,
> 
> thanks for pointing this out. Why not just use:
> 
> n_cpus = get_nprocs_conf()
> 
> and let the user pick the right cpu id with 'c' option (since it is mandatory)?

Not aware of 'c' option. Yes, get_nprocs_conf() directly works too.

> 
> Regards,
> Lorenzo
> 
>>> +
>>>    	/* Notice: choosing he queue size is very important with the
>>>    	 * ixgbe driver, because it's driver page recycling trick is
>>>    	 * dependend on pages being returned quickly.  The number of
>>> @@ -757,7 +760,7 @@ int main(int argc, char **argv)
>>>    		case 'c':
>>>    			/* Add multiple CPUs */
>>>    			add_cpu = strtoul(optarg, NULL, 0);
>>> -			if (add_cpu >= MAX_CPUS) {
>>> +			if (add_cpu >= n_cpus) {
>>>    				fprintf(stderr,
>>>    				"--cpu nr too large for cpumap err(%d):%s\n",
>>>    					errno, strerror(errno));
>>>
