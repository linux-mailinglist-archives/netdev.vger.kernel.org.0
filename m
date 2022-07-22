Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C46957DA11
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGVGMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGVGMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:12:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E52A405;
        Thu, 21 Jul 2022 23:12:05 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LJkjnj005571;
        Thu, 21 Jul 2022 23:11:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jxyf7fJqEfbGTHHyEsXWrNTHTDbw+WkUkjKW0uDgyqg=;
 b=XFswxkD0faHjy2VRaUq3gX0CQjlZq3spRwKQAdLwm3pCWX+v4OZHr9FnDlMgLuY+zIZz
 lAvkmz2Nw8zgi7BnrBVocENgbO7GLV9Znurgl1e0wW4Wd6Sy1hNFp59ZuRzxxcTdnrh5
 6X6hIYOuNBEL3C37J43RU/AL8gvSZbx3S/s= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hehn2vp6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 23:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVizv6Au5ycBWFzrS9ugzRhZ3+4FGvm9o6DeD0rTDhrgJzHdaIO+QBCr6OsEkdxg1MZgM965WSK0hYTkrkY9F8R0zFK0xqe1Lo86q4W3xIOXGZOMvG0tTlqrjfHvgiRD816ePMZKdMJfggWG3TsTB2WSQYAGlacDRpWhEiHBx/RuyqPLfpRySUOJRpUrDyHYMeYiHLqtI1tmIGmjTjK3jdy617skjuFCThurCObtywq5BVa3Qwc6ZEkqOf9EuEjhS2ooDVGcADJs8piwfHklCK1dR/TFh/cW5bIPxFSHED/KdCsU1ZaPqNlq8CB6M4HV3NHCXeT3JjSoJaX/6zUPow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxyf7fJqEfbGTHHyEsXWrNTHTDbw+WkUkjKW0uDgyqg=;
 b=LHWz1yqiYQKSha9mQwwecHRRtCgodM4QVBPFa0kCcYYHSzt7AL2IgYURuMjebVLjN7wgVL1olHDkvS5FARdZtbf9TIdM94GF/P2nxI3gZhxtYxELpmNFCN8BNu6VmZyNaYnsnuzzpBJ6NvWh29kDmWus3+RXAIdRHiB7ASmGN3wGhX619JJkdK24MQ7BqecN4kucdGLK3dj2lh8lFRrjd6xSSQoNAzRKNbtyeNL0Xw2Bqx12Ktxtuj3s1DvnGbhaUKcmvJlxT+RJTIdIujHiTQcjlup906j2dpdGdTGHs1xzqGW1UT1yrwkUupfX65JPnr/ctV9y2zwp7rcloAT8Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SJ0PR15MB4328.namprd15.prod.outlook.com (2603:10b6:a03:359::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Fri, 22 Jul
 2022 06:11:40 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2%9]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 06:11:40 +0000
Date:   Thu, 21 Jul 2022 23:11:37 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
Message-ID: <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
References: <20220721172808.585539-1-fred@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721172808.585539-1-fred@cloudflare.com>
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ea058df-5384-4944-8ba1-08da6ba90a8f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4328:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06GXRo7/XA2ysd70VekfSrUNT0fq5IDv+VzcO+pZQoBcLETEijiDAuAI5FZYfHX5TGCG33nJ4gjDlmtDB8GkIogWQ/YJgHPzSr5+/BU1/e60G6H5sMKdGKSd6lpH8E8QgcUP/kYiIJe99h/tsH52UAxgNTFsm51YU88xG85XMJdzPN6jvIzx3pGs4t5RvyHsezDU+AAg8sqxk8zksfAD50GZ/9wuoyl3rAD6Z4vZYDgucmxdAaQiXg493e7ccfQh7TFDYj/dVNUIKHJRu81BCLXFPrbf8odJjFs3sf6ympVpt9sDrUiAtxR3ebxq18VeLUQUnDSYU2u8zDS1KBPqDrVYY/qLK++jUtl1wWFEDAu6Z9AJQPuwgBP7sJWQF4qH1WPXd2gpv3x+CjqUIkd8fGb4J2A5SIJH396lRlZiHdpfFiWLjypOVLT+BZ70Br8yVyU+h7wn1tvCEHAzUhEN2VhiUmKsJduAK0IhtQjD64NBnwa6CxyMe0rDlqiXTh3Zt48ackg4j3z3PC8Bhzs8LJsu853nOKhTziAdPm9CV4V6bK+uFeXeSOtppt3lCp8BEpuYMy/96fulYugUZ8L3WoeWYQjiSrOYC/AhuKNRgdcYlhzHocK7XcbYvC6kzHTEBfNnSpu8s39SRbA9Pj/70fW17FnwYv4j7kzOyH8umA5C6Q0U5Oaif/tFXA8Rv8BUyBeG6aqQ1TzjTAticoUCMDq2tpFe8832BRJwWKlue2WRqjsb1Mp8HHZhUr2uCtgr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(316002)(6916009)(86362001)(8936002)(7416002)(5660300002)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(186003)(83380400001)(38100700002)(41300700001)(6486002)(6666004)(478600001)(6512007)(9686003)(52116002)(6506007)(15650500001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ETPW4kDzs7kZljRE/+D3C/ZFCjpnlcZy5INxArRhtEzP/rbJl49+PmjkdFLU?=
 =?us-ascii?Q?SAQDmMl3DxLYT7t6ve/NRcjKnSyVDT0T8/7QvhBINXyc79z4NHs5RMxeN6i2?=
 =?us-ascii?Q?PW41XCgPxzij/9SQujJasGvGgrUGxvl4a/b7r6Jb4zJPggiXor/bijeRBjjT?=
 =?us-ascii?Q?tGJy2joKHQd6/MeqVkW0pBUuJSu2XdLP3uLTVwJ1I5Zr1f5HqQnLl+ncvq3D?=
 =?us-ascii?Q?xvyHmc7T/aPThFyR9ebkVDYRCTq21T2C2r+S1A1ZcUlNKqFK1PrU+lnj0Bvi?=
 =?us-ascii?Q?1HRFJfo/5NOqqMD3boZFrsH+BxpdxUuSVbCMw9tovaXcKASVpxLpz8okCfmf?=
 =?us-ascii?Q?ELBY/ryW/4hwYA4L1+9Q1B8z9buCzllV6iayNw62CLRrJ+FWFHXl2bmMo05f?=
 =?us-ascii?Q?F35TBspGA9C9AMYW/1e1laC8Be4IkD0Fa60lqp0WDmU0ENv9z3t1WHzv7i6w?=
 =?us-ascii?Q?o3ibUY7nbIYX1GH6evTJCYIxTY+z+kutofbekwkWSijT/y2ZFyQNVLnVcS+9?=
 =?us-ascii?Q?kPOPUbLWxiDCCAoeD/PhUTydqlH6D2AAVjsPX/iETq5Y3dPakPHBT+8tnEPO?=
 =?us-ascii?Q?dBr6oAUK+dbMyoQArJnfXBsa4w8iQmGAMlzAtJWkMMH6u7+uphom0VS/N/Yj?=
 =?us-ascii?Q?ytgykIhv309JZGA1UqQx8mpHD+QdbMq600hx4sUbe9IPOnvB6v43ysoDPcOE?=
 =?us-ascii?Q?kkuEeRvrOj4OLywXszBRQJkKjWN+qGX0hzP1B25loD3jeir5ZEyLBY5Of0Tm?=
 =?us-ascii?Q?9LMfBWJK9ZUrDXAfYvq3+azfSj52YfxOOqYDXZZT6aNZZU+5596fOd0dcNpY?=
 =?us-ascii?Q?jq3gT2B7yzBeIud3cjwc3npJL/OaJQISV1gpQPHCu8A0RonYkD3SfT+7bM/D?=
 =?us-ascii?Q?fShvVrud0YPMyvljl5VkYEyh4mtCibEKqBx0bu0HDkCtJ5lFcyYBew7WgSSh?=
 =?us-ascii?Q?S6KQKcpJjW45Qm/+x71ly01jvEB94Gq+Ep6UjH3B6/gLeNDSpD9j8T+HGxOQ?=
 =?us-ascii?Q?stVmcwDPit8sEEUg3iyb5Vi0RaL7NKgN3NuEz1iZqti+xcMCPygPVk/ATTh3?=
 =?us-ascii?Q?+e0ZpwGkUpgpRwCzmpxJ/VTMG4iWY2vYSMEPbXcoljVX7f8Hy8S0GRhpURAr?=
 =?us-ascii?Q?9yZf4qp/jogxEaWmNF/XXIxrpZ2zE/94kIV6qVtIt1aybooyFQj+MXQKf2V/?=
 =?us-ascii?Q?/R5GOOwW/5bbuCEjpvt+XFsl4Pg1G3mNo7V0s2qgwGhRLeHW1xuFRbujq0KC?=
 =?us-ascii?Q?QWVmPdqDhgIt7rpxaPBwlXxnNCShWOzjGKN82vtGxgEyKvvLXne2zfI7elkV?=
 =?us-ascii?Q?/3CHz68Hl9yUzacIdDJx+aIVxoDiUNvR5E6+xp9GE71FC4aRNqavjQcnC4Hv?=
 =?us-ascii?Q?zmK5WZZAaXbTa/LvrIG/4goSAsg0CR5J9ioU3Mm56ZPZgr/j6onuVMBb2YJM?=
 =?us-ascii?Q?f0ELEctrOWIYeY9vqdC9a7zdOWQPb/+F/GAy2cUeRUM/1WMpXPs+tQ5+oEqV?=
 =?us-ascii?Q?x4NEkAeyJNShCujlmMgQyuS8sHDMO7GIdffRD+jTWcbw0e+64sJWWifLIzTi?=
 =?us-ascii?Q?YiWVP0qjG1ewWA5lrZJTXZNrI6WPv1fPoPUIWlrjRi7vQVevSqqJfZTQpcdP?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea058df-5384-4944-8ba1-08da6ba90a8f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 06:11:39.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKjWgYOy+UI/ylJd3yKQMh5paPyf5epSIudMvJ3JCzOpkFxFKQ6wcjqbGhirMS/p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4328
X-Proofpoint-GUID: fNgtJ6KDVgM05xSMF9OI1uMuWXKF2vjY
X-Proofpoint-ORIG-GUID: fNgtJ6KDVgM05xSMF9OI1uMuWXKF2vjY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
> While creating a LSM BPF MAC policy to block user namespace creation, we
> used the LSM cred_prepare hook because that is the closest hook to prevent
> a call to create_user_ns().
> 
> The calls look something like this:
> 
>     cred = prepare_creds()
>         security_prepare_creds()
>             call_int_hook(cred_prepare, ...
>     if (cred)
>         create_user_ns(cred)
> 
> We noticed that error codes were not propagated from this hook and
> introduced a patch [1] to propagate those errors.
> 
> The discussion notes that security_prepare_creds()
> is not appropriate for MAC policies, and instead the hook is
> meant for LSM authors to prepare credentials for mutation. [2]
> 
> Ultimately, we concluded that a better course of action is to introduce
> a new security hook for LSM authors. [3]
> 
> This patch set first introduces a new security_create_user_ns() function
> and userns_create LSM hook, then marks the hook as sleepable in BPF.
Patch 1 and 4 still need review from the lsm/security side.
