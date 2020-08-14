Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF6244C74
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgHNQHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:07:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgHNQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:07:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EFsqOc025458;
        Fri, 14 Aug 2020 09:02:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ufd4duYTAhvAnjBhNzZB0MUIgt3uUt5m70gZfAlc0LM=;
 b=BF659orGKE08Q66jRveh1dKafd+lDBUhOK1lRUVjgElPlbMPKl02Hj56FWwG06EXS8k8
 k4MV0bMPUZaAV4trc5nZjmne0TiEbv5S7HwIwefOylBMvzUmEwyecBRNNoiyZ0GYGY2I
 teo5/f9EB9pxZ+EXiAQvBI+RgZHEYBABB8Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kg85r1-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Aug 2020 09:02:06 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 14 Aug 2020 09:01:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cteqkY/cNioHX1hjhqgfJIsBTG981yVLaQVr3pZjJvGnMrmnKrWUY0tNA87YA+B0s9gDCh6bvvxJIm3WzZmoHf4n/glGngVqGrZDv/tYdD/b96pNvSdkW38wEhX2do3z/tRfOvLGZudTXEmiTEneMEyzfKI55DdsQ6YEDsc+0Kn6NKwKFPN2ZG3hJp8gKmle9RTw9Fwj/WvRKqiJDTFLHJ7IRXDU82ZqFVRd9anyOF9mcGOubPVOp4Pj2kI4AxVVPUnkdocvAU50Ni4Sfn4QmxtIUmUHlWVs1+YDIURwN8gc/d236ZqhmIUbprzQK+UbEz/ZAJ1rfnI1l/Qjg4a5YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufd4duYTAhvAnjBhNzZB0MUIgt3uUt5m70gZfAlc0LM=;
 b=is34gsjxpGuq6SuCxXwrKzh4zvmB02x/XZrTzgtmfdamD59SVq1/aXMl6dVVGmG6vI9zCCSZmU3J8CYHn2nKZEQiFYt1xZ11ezC8yu5ANeCsjA96ibS934/kc2Q25RaVnvEUE5JRIYmUkSgHbcoxTOtPfm2rAG75pp4sgqUcWrMoBOphOn9SMpII0xsDpWyTYUWr/d08YOkmVkA+jjxX/DkqCcbnMPS0URl5UDkZojuKzHD07e6Jh/j3XMrKzAr+sqd7PkZWNDbGz+F+xh9vaPhpvGMDO3R+KlZuvfRBQ+YFtsxgC6wAJnLS9Sv+JARA7jH5kkptKN/r1OPOJPZGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufd4duYTAhvAnjBhNzZB0MUIgt3uUt5m70gZfAlc0LM=;
 b=bu/JXEFcVF+2B54VCT0I2adt9n8dTnYP+OyvoGMpuWEll7a3bf1ZnM/k3dXmOYJTwECFUlXdYmmQkLfSgnYN9csQ7uX48IkFzQrX8OntZ04gsusoguqWHzHUuiLwx1lFcKe6ILggBv3KaLJdZLnBuvmCmiH4N1GVm+d/uKu6fn0=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Fri, 14 Aug
 2020 16:01:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.020; Fri, 14 Aug 2020
 16:01:42 +0000
Subject: Re: [PATCH bpf] selftest/bpf: make bpftool if it is not already built
To:     Balamuruhan S <bala24@linux.ibm.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <naveen.n.rao@linux.vnet.ibm.com>, <ravi.bangoria@linux.ibm.com>,
        <sandipan@linux.ibm.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200814085756.205609-1-bala24@linux.ibm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2190c03e-fb9b-7dc3-bfa1-7d289d6b68b1@fb.com>
Date:   Fri, 14 Aug 2020 09:01:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200814085756.205609-1-bala24@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::117a] (2620:10d:c090:400::5:238a) by BYAPR07CA0092.namprd07.prod.outlook.com (2603:10b6:a03:12b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 16:01:41 +0000
X-Originating-IP: [2620:10d:c090:400::5:238a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe77b0c0-1743-445d-279b-08d8406b5649
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB245321BC46A71FA9EED72494D3400@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AtSlnmz7phRjvnnHE+mzZVfl8tjz/0i1ZCcGK1hJweAPPLkVRAAUl6lJQVteSpEQVqUDlleeSSg/SVndwnAQp7GVEQc9eCZ7Opnc5J7yNYCeUuiyuba5j8xwmapCG2syPMlFEfg0glas2hpO/PLYP6M2ZGi2dD9bfOVH02EuYUl8mZh+BgKgbR+g2fi/bYcroxVvg2HYt1pZLIVZ5RBgMs/EHvBhBSwx3YuyoxGvf8vkVN5ykBGDoEvC+Ih27HOYXA9m16UlSR41S9M4V5rRjMMdBgHl8nfsscNFvym9KbYb0MkiMt9G/I19QuNdxuNW/2BnFND7dwQGFNmbFCD/2wy22mHrZeI1j0fHOS7LCgG3ict5aRBRniLHtudrUQw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(52116002)(316002)(5660300002)(8676002)(31686004)(16526019)(186003)(2906002)(8936002)(478600001)(6486002)(4326008)(36756003)(53546011)(2616005)(31696002)(83380400001)(86362001)(66946007)(7416002)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Y2dheRwAsgPNMeOP6vUVbfSC/RIWpg3VUdJVZfQBS89RY8rtmFiOc1W7T7IBQKOo+tkrOClxc1C/v208Gev8qtztl6HkVmrffsBmiyu/OOU1uzVB53UOQm+cdilvFjtp+bEfEAKFtLUa8hGYKRkFKojR4dDZaet4TCx8Aqow5Y8aT4BiTAsPMop3zMeXLIVpdCUsy13pTIrIJbXzbEJbzMGRruQEXVjJRzdhfQWRu43VvbNp1PjGqZOgSw3v5/4wWg/EJ8Oru7NiLc7gSkPX94hiHJmhMLdQiP/ZPhQEI17+qnupRGAddtR+rl/EDfq1g1qfkGPi001v746neXmgLxb1Hs4bWk2GjBrNE8oIfFFL4Fvck7Ngh0zxpA50Rb95an4ORWe9Kr3+rdx0HGUPw7arjplKTd9aR8kYxUkM2tjcv4z6+GPbcCYVXW6Km+lJFoHR/qfdUtugGIuMYLugUOBGbMDMrQZL0RdiuUyWM4632iNDFfZvDFA0ZzA7dSlZvDMyXtnahzn9gGqLUsbSXuhA03iHlx+4C5X4WKfSyEaZGOR5wrCpLi5PX8OfpD2X5svLp1MKXDDmylBo9mJnhGEuzLUmFfIYTMP5qRCjdfobLV9pINF71rsWslBWv16fZNEQqY4IiS9ruajUUJADaJxr7lx5tb5wkJ89Rxlh7lI=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe77b0c0-1743-445d-279b-08d8406b5649
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 16:01:42.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjNqlgkj2fjiQEVvisYbAlPJDPEa+K7YdSW/tJzMaRGH4+JrsUxsbO70e5eRFasH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_10:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 impostorscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/14/20 1:57 AM, Balamuruhan S wrote:
> test_bpftool error out if bpftool is not available in bpftool dir
> linux/tools/bpf/bpftool, build and clean it as part of test
> bootstrap and teardown.
> 
> Error log:
> ---------
> test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
> test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
> test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
> test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
> test_feature_macros (test_bpftool.TestBpftool) ... ERROR
> 
> ======================================================================
> ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
> ----------------------------------------------------------------------
> Traceback (most recent call last):
>    File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
>      return f(*args, iface, **kwargs)
>    File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
>      res = bpftool_json(["feature", "probe", "dev", iface])
>    File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
>      res = _bpftool(args)
>    File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
>      return subprocess.check_output(_args)
>    File "/usr/lib/python3.8/subprocess.py", line 411, in check_output
>      return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
>    File "/usr/lib/python3.8/subprocess.py", line 489, in run
>      with Popen(*popenargs, **kwargs) as process:
>    File "/usr/lib/python3.8/subprocess.py", line 854, in __init__
>      self._execute_child(args, executable, preexec_fn, close_fds,
>    File "/usr/lib/python3.8/subprocess.py", line 1702, in _execute_child
>      raise child_exception_type(errno_num, err_msg, err_filename)
> FileNotFoundError: [Errno 2] No such file or directory: 'bpftool'
> 
> Signed-off-by: Balamuruhan S <bala24@linux.ibm.com>
> ---
>   tools/testing/selftests/bpf/test_bpftool.py | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_bpftool.py b/tools/testing/selftests/bpf/test_bpftool.py
> index 4fed2dc25c0a..60357c6891a6 100644
> --- a/tools/testing/selftests/bpf/test_bpftool.py
> +++ b/tools/testing/selftests/bpf/test_bpftool.py
> @@ -58,12 +58,25 @@ def default_iface(f):
>       return wrapper
>   
>   
> +def make_bpftool(clean=False):
> +    cmd = "make"
> +    if clean:
> +        cmd = "make clean"
> +    return subprocess.run(cmd, shell=True, cwd=bpftool_dir, check=True,
> +                          stdout=subprocess.DEVNULL)
> +
>   class TestBpftool(unittest.TestCase):
>       @classmethod
>       def setUpClass(cls):
>           if os.getuid() != 0:
>               raise UnprivilegedUserError(
>                   "This test suite needs root privileges")
> +        if subprocess.getstatusoutput("bpftool -h")[0]:
> +            make_bpftool()
> +
> +    @classmethod
> +    def tearDownClass(cls):
> +        make_bpftool(clean=True)

I think make_bpftool clean should only be called if the make actually
triggered during setUpClass, right?

>   
>       @default_iface
>       def test_feature_dev_json(self, iface):
> 
> base-commit: 6e868cf355725fbe9fa512d01b09b8ee7f3358f0
> 
