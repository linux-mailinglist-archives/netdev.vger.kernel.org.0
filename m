Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6C49BFC0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiAYXyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:54:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12880 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbiAYXyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:54:06 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PMO3c7022634;
        Tue, 25 Jan 2022 15:53:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CP4+RF5HI6hG7E44gon6LkBA+oHD020hS0lJ/eVe5Qs=;
 b=UF2biwBu+QxbJEXvwlexj65FPPl+5Gk8xhB3GkFGyJSbV5k5CtceQeYyqmc8plfjGTCD
 jSjh4OhOm+HO4EJw6xfIaBtCDvJsk7u5+QxUyprZLUt9qJNnTn+/GJlcGEleWsCKef+w
 rhvbQfO3MD/cQh5TKCevImlCm1xY7fHGpjs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dtfjgcxg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Jan 2022 15:53:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:53:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdYeTF4DZg7Bskt4OmKYENLb/IMt7txZw41qnShnNm0LY8DRjzsf25sEirby1N24Fd0fROIgapDAXMDMkzesJyT0RX5i22ROaZJTOG8/ODxQzXzBsDE8b4gGo4qZbTqt4r8FbVjSjZsEgjxfhZzXao0Nz4DxFp9uQUQRePZcY/yWihQcKwCABfGR/VaRUpX4O9HuIFWOnm/QHvEaklzGhOfre9XOVx31J33Wwz2I+gs92lPxrLhgdKWncrb6bS5yAbDbwcImNoTwbNtptnSa0Ye7lPR3RnspHcxieJFtMdsNWFbl849M8UjI4gkFOWRSfIT9Ydd+PEZ0js2lhXyuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CP4+RF5HI6hG7E44gon6LkBA+oHD020hS0lJ/eVe5Qs=;
 b=IeIIYcugvN46f2TmsetHOfCaPW1qRmHwVDxEQsmmv4nnStG5H1w7va4qHom+a4iYtXiZehYw/qPsBKZJAH44daVxo0Gu4zy/nOA6zHwNtnZfFCCMmTpoHiNvvvKDNm9DvDeYs6jn+T5ZGnL2y7viZx1Yh6sWFavyijfFJSRdZuEsmAzc+PUqApcCoqm320djWWgBBo/WQp0n3FEoWa4DjhjlR8KYIHp7YoYOUSc10pPp07X6oRlVhLLAwcFLctDzJM7xSwUbhWsw1eB6u2ZCTcsUbw8a6lydR/gW79wMDUVQz/M8L9jcj30rL3RzUfSXEM0Gny5V845pK1k7VZ91fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR15MB1436.namprd15.prod.outlook.com (2603:10b6:3:d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 23:53:23 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 23:53:23 +0000
Date:   Tue, 25 Jan 2022 15:53:20 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, <flyingpeng@tencent.com>,
        <mungerjiang@tencent.com>, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
Message-ID: <20220125235320.fx775qsdtqon272v@kafai-mbp.dhcp.thefacebook.com>
References: <20220113070245.791577-1-imagedong@tencent.com>
 <87sftbobys.fsf@cloudflare.com>
 <20220125224524.fkodqvknsluihw74@kafai-mbp.dhcp.thefacebook.com>
 <CAADnVQKbYCCYjCMhEV7p1YzkAVSKvg-1VKfWVQYVL0TaESNxBQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQKbYCCYjCMhEV7p1YzkAVSKvg-1VKfWVQYVL0TaESNxBQ@mail.gmail.com>
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae82ff7-0fa2-4ab0-b21b-08d9e05ddf49
X-MS-TrafficTypeDiagnostic: DM5PR15MB1436:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB14368C3A6CD44201349EFE6FD55F9@DM5PR15MB1436.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3hl+Zt+ZUrLCa8gGLp0ze/bMF483qZIpDNNNuRoWbSiwCv941gEd9w2FDCA2CbkhzWXfFfZTfddpvruaqi4g5kjIEUTUZwfuPXgPVdLCc0r/3/3hiK7smQ91hJzZ28RPhNt2ENbrxYQbSl40p5i/jhWDEUHPd5NnpNXJMAv5Q0hmQIhtqCMIR9NVihA9KJ/xZdSPuOJ62NpNUSkbgB+3i5H+Nfb1Dm3xG+tVzJcOqWg320KtG+XlKAPbWgenGZ7Em8ry6jtnMXcLhnbpa7TYKSIe5SngQWld76mlF4FlEitRbki3qzPHWdmIA+Fhd1TO2gOnKer0JkNeOvKnRlHP+Cc5TDpxzJBIhImcnnnNGJ9fk/5bu1gBkjuKxuWmJ/p4ykvZVTYAzO+mR+OGH0rnJ/v40OqEVkJraIp54ro7EFJO3epVXD3LW1m3sW8XbnJz4Mjb7L/rcgNxOll/zdkwlqzBKGiEMDl4FR2hoye3tbEmYfsbdRQh1uYyT/vpuiRywfuN319zgL/HSWBOTW4kkwTspfgjHH3ojyojLJcLDJUURLlC6gBnxVCQAUlYk6bcyAouV9SPe7dIgiWij3jV6i5Bm+xccvi6+QB5453wY5Qr2Xe8fl63hczO3gdNVi5eMviF7rOfpuphFQ3Zo5Fqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(66556008)(6916009)(66476007)(66946007)(5660300002)(4326008)(8676002)(7416002)(8936002)(6486002)(86362001)(316002)(53546011)(38100700002)(186003)(52116002)(6512007)(2906002)(9686003)(54906003)(6506007)(83380400001)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+56KRqnTdu+J7Z7b5ufyH3BctUUBw/ZyrOnnWerHG1YIlQd2ragfh2F8BBmQ?=
 =?us-ascii?Q?AUe3y1yI6WylkCebYVB8emK1rDbwXweA/4NTeHtZiGZdHBoTKA+7Z2Pu8T4d?=
 =?us-ascii?Q?ZIc4zndXSGSTt3EDI91PsqQeexRONoCcRJitwbsb4Ghpvj+UXifu9QFbH9X4?=
 =?us-ascii?Q?6w3db2nM0D64CieKTkd/0YD9u19ta4TgufY3WWCsB4fk15+fhvE6I6B2ECmW?=
 =?us-ascii?Q?41eQQz8va9xjqRir6uW+PZOS1YIeM0AIJ4z1fAHpPQzlFB98EdwrHvSt69+B?=
 =?us-ascii?Q?TCoekJs0FvmVkgijVnh/d3BPKSozxJ8JFBrFDBy2evlJGaGRBGZYjSg2btME?=
 =?us-ascii?Q?nxCdun8H8GddC0JD0AK+3415TyxGJBPusL9VpckQ/Dd0ShnocbkwAz/AoWyd?=
 =?us-ascii?Q?jb/h9tq4cPLCLQZziyCokiRltBwhE62d4kMUgjBpMZxrfTlwnatmWrPLZTVg?=
 =?us-ascii?Q?3/eMTb039di9n57Lx9NmtVGIYD6RMgH5ID51AX0cSF9m91HtXyyHM/xjE0Mh?=
 =?us-ascii?Q?N8Yn0eK5v0nRGk+E2/Sz+MSsq7eZLNydueAirFud6r8zom9R1ht2yRlYifTP?=
 =?us-ascii?Q?ugdRFRCCdrJNZtc9YR/3KioJ+xypWvMfVUgqB0fUx0Q9Hdaur0O7/arcWkm7?=
 =?us-ascii?Q?debjfj9j9DSwk7dRVthkF862pjxq6mK7p6WwfAhg6/X0PxRR9mxToES6/MyY?=
 =?us-ascii?Q?cAfCv8+leXOQUGb5iqOuVqeosLPM9nqNSl70Ku15sjHYEBJ1agfVyVF/IKcU?=
 =?us-ascii?Q?H+RHRpBuFRZipxv05X4h9M/R2rgDhV7l2YMH1HBTG/gX1ysiLEHnuOCUNs+B?=
 =?us-ascii?Q?vNcmYDVLQ011Yg+zExa0EAsH3R/o22NbOZs5CBMXXjzJNUPrmzr+p4G+S4c1?=
 =?us-ascii?Q?4/vjvZWMVjWLm4CKiV8axrVUXbxuXwi+tcmYBQYatwwUGE38iEg2EI8pxC6q?=
 =?us-ascii?Q?y67Q5cQe68ZOKa+2jOe0PwJPmkcUxpVXrejwZPG3HaL5BGdpCxNGU7oKMRpZ?=
 =?us-ascii?Q?SbkvWyIC3lxqjc+U6ny0iD0dSlX8uC3JlMW8pCtzIN5CfqIBHKzVqBAMNBUF?=
 =?us-ascii?Q?sBJ3mMJe7hakcFV8pjOYqYn7IsUZUdeD3hnMYp9v1Wl/bP+TM8pop8NTFWiP?=
 =?us-ascii?Q?srZOs4b/kWVMDGEuBgIj5Y2NU+Ss+U8UvtAv8/vHe61qMQSSUzYNqV1vKxKM?=
 =?us-ascii?Q?lHAw0XrPz0sHueZtzJzJAfne0LOpRyyQWSsswCs+akt8Cf3u+V4d8udSg6nM?=
 =?us-ascii?Q?rEVW1BG2/DmK4c+zCGW+0em8dwRvfYz5vh83Var0XuAnfFTzLFaiwCpN3TQ4?=
 =?us-ascii?Q?V3xakF+jAuaxUlSjyPHE0MOyPkwIkqWolDGBgLc6LmnFX7hHutGFdK7ZM7vz?=
 =?us-ascii?Q?eFft/FGWF1p51GEQ47X1xM7Vhlc5PGD75zveXx3tjlT+5a2m4Uw6kT8vAxlY?=
 =?us-ascii?Q?E2KoF+h+2cNHyn1q7lVIbxNOcVjn2JmH0KzzjtGU98tb/+MfrwwwF4Xgn33B?=
 =?us-ascii?Q?vyEM7DbyAiRr3upXSMuPzrYT7OlBvP+/9IhBlFl1Rh1JmxWI+bVeVdJS1iig?=
 =?us-ascii?Q?Gc9fol1Uls37egL5+csY7Bb2K7uINuItIp02HLvy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae82ff7-0fa2-4ab0-b21b-08d9e05ddf49
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 23:53:23.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYPRfNqMF3RLfAl7qVjtC0uSDCrBnl4KZC6MSV9i9bSG3HJySODj/MNDRntSu9GA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1436
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: xtVNz6j7RvZ6rj2OiqybuE1-0PaEKIII
X-Proofpoint-ORIG-GUID: xtVNz6j7RvZ6rj2OiqybuE1-0PaEKIII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=621 clxscore=1015 impostorscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 03:02:37PM -0800, Alexei Starovoitov wrote:
> On Tue, Jan 25, 2022 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Jan 25, 2022 at 08:24:27PM +0100, Jakub Sitnicki wrote:
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index b0383d371b9a..891a182a749a 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -5500,7 +5500,11 @@ struct bpf_sock {
> > > >     __u32 src_ip4;
> > > >     __u32 src_ip6[4];
> > > >     __u32 src_port;         /* host byte order */
> > > > -   __u32 dst_port;         /* network byte order */
> > > > +   __u32 dst_port;         /* low 16-bits are in network byte order,
> > > > +                            * and high 16-bits are filled by 0.
> > > > +                            * So the real port in host byte order is
> > > > +                            * bpf_ntohs((__u16)dst_port).
> > > > +                            */
> > > >     __u32 dst_ip4;
> > > >     __u32 dst_ip6[4];
> > > >     __u32 state;
> > >
> > > I'm probably missing something obvious, but is there anything stopping
> > > us from splitting the field, so that dst_ports is 16-bit wide?
> > >
> > > I gave a quick check to the change below and it seems to pass verifier
> > > checks and sock_field tests.
> > >
> > > IDK, just an idea. Didn't give it a deeper thought.
> > >
> > > --8<--
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 4a2f7041ebae..344d62ccafba 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -5574,7 +5574,8 @@ struct bpf_sock {
> > >       __u32 src_ip4;
> > >       __u32 src_ip6[4];
> > >       __u32 src_port;         /* host byte order */
> > > -     __u32 dst_port;         /* network byte order */
> > > +     __u16 unused;
> > > +     __u16 dst_port;         /* network byte order */
> > This will break the existing bpf prog.
> 
> I think Jakub's idea is partially expressed:
> +       case offsetof(struct bpf_sock, dst_port):
> +               bpf_ctx_record_field_size(info, sizeof(__u16));
> +               return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
> 
> Either 'unused' needs to be after dst_port or
> bpf_sock_is_valid_access() needs to allow offset at 'unused'
> and at 'dst_port'.
> And allow u32 access though the size is actually u16.
> Then the existing bpf progs (without recompiling) should work?
Yes, I think that should work with the existing bpf progs.
I suspect putting 'dst_port' first and then followed by 'unused'
may be easier.  That will also serve as a natural doc for the
current behavior (the value is in the lower 16 bits).

It can be extended to bpf_sk_lookup? bpf_sk_lookup can read at any
offset of these 4 bytes, so may need to read 0 during
convert_ctx_accesses?
