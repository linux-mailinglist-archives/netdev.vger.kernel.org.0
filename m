Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C51C5FF0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgEESU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:20:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1538 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730258AbgEESU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:20:28 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045IFKNN025271;
        Tue, 5 May 2020 11:20:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=r05Fo/FuCOGhaEmkBu4vJmJrHLjJnZzuGVn5j4FRr6w=;
 b=RQQIS2MBfZfeTLMmLOP55y/UQipABHBtXbkx927aoZRQdS60S7aw3BDHb9Jh+aDmb6QM
 +TQppf4DiAF2iBLRl9ZwqFlxCattmjOu7PAYkNcoR6IGU07clG+g8yy+MjrXesZfZB5x
 8rwkT9f1Rc9LOmKrgwXuB8gKRPo4kj2fHYM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmqxa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 11:20:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 11:20:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NI9eUetv4XHA3sH09kH4Bc94avz/NNiVCeELXQkZQ6YsV31hDBe06x8+8xsmXCr7418fRXtcDBhNDtqVVdywHMQaTyVzg2YGo5m1uAaSKRr/NT3lBG20FXAnHtn0FHapCJEgYPbR8xtMTTU6oIwFNHty5KxvylcLmYzQPZDCMZn3kALfRqOg6s8VSaAVNp2uhIuU354htUC8A18Az27r0EzaFocUlbArGaH3xEZeyVxyivYrp4ip78cId6xuMIvFLeQYJEDmzxUp+q3cOCh/7Mt2DnhA3GAkCw7HdXaSXhP8SEIsyDhslIIKAo2rJC/wpSCoOAhyE8VORy/iTbIevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r05Fo/FuCOGhaEmkBu4vJmJrHLjJnZzuGVn5j4FRr6w=;
 b=RdwNUZSnkqkhQJENeyladfFZA/m1PvID52dy9lT7pCHj5nx4OkEh4Vw7Pyz3rp+adk2mhlP2PyWmipm2Axd8nUFNpKo3mUm371bOS6g9aNQiLLkH8pjBECtvkbVV38RsV6rHiu0FCCz1Pj+EhYzjgJJ0zX4gpiE6Bvke/C/obTHRmylmA6dRc0ahJu9I+iWv+15n4zDCEYlWf0fUg6jvdX/NEVtORvvI5Sg+g7HJJ7t9PukUbjkQC5MWsp+ETSVCubHXiXKRCkw0hqZPXu+odAjNqQYV0Ifl87qPkXByT0y0jx+1gKmuYoglEXxbLhAlhWENOM0Rmf5m8b0k/Z9u1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r05Fo/FuCOGhaEmkBu4vJmJrHLjJnZzuGVn5j4FRr6w=;
 b=eFSV+zO//n5+1GERCIRUSnV7/mRgBXBASKg5yHqhpF3pluAPnfEzM7uV3OCafaMUSf885bi1l/OjGtqFU2BSK3L3yYDBRUOphGxel1lbFu/Zvap2e4SPS85pe5yUSreT79SrBWq9NohoFIkRNSZka+PwoxbF8dQwxessoazEnlg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 18:20:11 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 18:20:11 +0000
Date:   Tue, 5 May 2020 11:20:10 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 4/4] bpf: allow any port in bpf_bind helper
Message-ID: <20200505182010.GB55644@rdna-mbp>
References: <20200504173430.6629-1-sdf@google.com>
 <20200504173430.6629-5-sdf@google.com>
 <20200504232247.GA20087@rdna-mbp>
 <20200505160205.GC241848@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505160205.GC241848@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BY5PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::40) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:d580) by BY5PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:1e0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 18:20:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:d580]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c735b65-9a87-49ec-4b27-08d7f120f2c8
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR15MB346176E41EFD03D3C023702FA8A70@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKT7bTkL5SCNPkg2TUY3mtRjEf5mXdTVBkhmy1mQcAXhaVOD8tYyUFmeqmTlUyyn/+VT1KhCaj6H/2p9j1vADXO50TdGruHKIeMP0mveHqseQu48juJZvyOqsoGJnVFN1Q5JKR1tb6WC48R6zu8MD+eTarIivO+xkX13riExAd4Bs2820GJWm2ipNY6YFYM94v9DgSbwQCFozlt0mujm2cnzALMoW/qXsu1u9DJbdcD6tYZKAIzQ7Ga+m90+SvQ9yCT8k3ySbSyzSPWp/c92DjH5AWdD5l3KDoYX/ts/hVYzGBhMhuxrKbBi63pE+mRJKrQh1rxx1knZY3R4NrD4jhjhEjXsv+X4IGqk4JwvdTRLJlRx1xjAHnUEBajYoCE8tmbuchMM3D0mw1Xv2httU2XtCUvKB2sn6tiH1nGndYyAdyxXWw+SUban71uk+G/HjCnKgjtn5yqjWAvIPzj7s02JvuvNTvOjbOOXzde88gE3HUVk98nPn9CzM5br6vgYxhpqmbUHCda2x93YptBEdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(366004)(33430700001)(52116002)(6496006)(5660300002)(1076003)(16526019)(186003)(86362001)(2906002)(33716001)(66556008)(8676002)(66476007)(498600001)(6916009)(8936002)(66946007)(4326008)(9686003)(6486002)(33440700001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gFPEog+pWv2paWDswihOUPFvHmTGxHaWFoWwlq2lMv7BPegFB2bNoLrF3/ssF5C3bISVmnSFlnRf4NNIhTzXjesMjw5Ui6aoEggI4Yox/6Usc8f6FnThIKvirGqeAI7ybn3wdZw9vT2fEKIKA63nlxHnxdUXRV8yoXYqsvU9BRkVsE6mfZZKV3sSLaYlK8F+dQ+KvVX1jzbBvmJNCJIN5Va9uPs5pySNotMZ5JyEjM9jWDQtrOfYenksWftQ9zhbQ+Dt+9SYc5pMyR0ejsEKnLaMMNaRGk3tHVR8MO8sjzXmRiIII44cSttDeKzB7laLaKtSdDZB7n69oP3sHJquRyCPGTdIr6xsB9uPW7QSNFQlDm7DaCHduka+LAsjHP1kwCe/j54nbQ1IM+ua+HiPFLZ0r5ZSCb0fSd3egj8w3KvVJYoUsV+ixE79g54szyWpuVwhDb4EBlXYrBlXKRZBywl8UYAFOYtP6fsKwyq/LbRChWZhHtRF5sJRCPTmNL0GrHqXawMd+0zLtFSqV22eO8LXdQHZLtFPydalcAJa4xd6h2HOtIPFqkm71+/PNC9rGkY+lk5R0qcZ3e+fGnU82VLa28GkqKHKqCh2awIJFPP5DhRc9n3Bc+NCJyqUzCw4KdT7fND++Yal2PFSI2q23D+ZPJz8fOQYy0MhwRItWWEML9ipKSDIjSdozOBLuSd3cU7/8CORoUsDkn90xfa2aBwFlmB1p0BU0O5vOVZJxUH3W/yx2W7USw8Jz3z+toAh31+qQENGi0+Y2U/HdTjtaKSReMDMwz/v+KnyUBxa6G4WhfVY647evoEblADyKolT15mAZcTHC7VXDPNfBmz71A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c735b65-9a87-49ec-4b27-08d7f120f2c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 18:20:11.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3PhCa1+/Bc5cS5yOL2AJf8d0e3JvjRBFQrMe+GJsf5nGinQXzGSRrp9D8A36zvqC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=1 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005050139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com <sdf@google.com> [Tue, 2020-05-05 09:02 -0700]:
> On 05/04, Andrey Ignatov wrote:
> > Stanislav Fomichev <sdf@google.com> [Mon, 2020-05-04 10:34 -0700]:
> > > We want to have a tighter control on what ports we bind to in
> > > the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> > > connect() becomes slightly more expensive. The expensive part
> > > comes from the fact that we now need to call inet_csk_get_port()
> > > that verifies that the port is not used and allocates an entry
> > > in the hash table for it.
> 
> > FWIW: Initially that IP_BIND_ADDRESS_NO_PORT limitation came from the
> > fact that on my specific use-case (mysql client making 200-500 connects
> > per sec to mysql server) disabling the option was making application
> > pretty much unusable (inet_csk_get_port was taking more time than mysql
> > client connect timeout == 3sec).
> 
> > But I guess for some use-cases that call sys_connect not too often it
> > makes sense.
> Yeah, I don't think we plan to reach those QPS numbers.
> But, for the record, did you try to bind to a random port in that
> case? And did you bail out on error or did a couple of retries?

Random port.

As for retries: no retries on low-level (no reconnecting to that same
server if sys_connect failed), but I don't quite remember how
higher-level behaved (it was choosing a server to connect to according
to some sharding scheme and I don't remember whether it was trying to
connect to next replica or not if current replica failed), sorry.

-- 
Andrey Ignatov
