Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76950574ED4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbiGNNSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbiGNNSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:18:54 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6945445983
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 06:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiXaim05U2vVKwetQjJT60gCPVIEk3YOWVL7Sht52f57WVy5UxTC6tonhCQptIJoT8jb01VVnk7/RvsKUlOKuRsZOgXZfeDsMqSdHTVtaHL/oG2bmDklbZUmWiA9mzJa962TGc0+IwTg6NiyBNdiMp8LxwxXf2KwxrU7SinuXZuB+/C8CGP9YUNRJLWC4AUiXbmhz9VZctYud9wjhGG8BQNCix2LzfVXNGtke2VzeE85YZXpz3VHviZSBVjjgi2NAIG75J/rfz2c3+cr8qahg0QWkUsvhG2IBjrrABuqSWtcI5VjkzTXDuelIFrl/yr7UgwYLUq0G8hWQbtPSIjMHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXG+hAnk9jsV/1Lb8mAKxSlXfIM5HTFF0MKzxy+qZSs=;
 b=ky6a6g7dVxZE7lQpYlCp1XAqTo+xEOFpnltNvnwdVFrrJEizrKRTgSpVOLnZJ2fLqHPNbWFmLJLKp6aT0dADBDDOh0R/5LjxRMh5HqN75lblCQLANSBSSSL7DKu9KimMYn666wUu1fbnJd3OiOAWmLNai0Nua0nsjMTflitW2vglF8byUMQVOmwXo3mGXM8KVXI0/WAI0m/MhwMcDseuK3ZsdXDKaho0p09oX8vjFGzDYkK91sjIQzN6qe+3Dl82XwXDaIk6CXhLKopgKNY30DrfiF7QEXSGZ5x9ZfvJEsbu5zjOUKSIDmWT7HorOkiB5SnPRlpfsbMsRTdrtIX+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXG+hAnk9jsV/1Lb8mAKxSlXfIM5HTFF0MKzxy+qZSs=;
 b=hP6BuacvfXAysGN23YATNsyZc4BMnglo1uag1ETbYDfpRbNizmTGH2Kb6Da6LIl93dpkteJBzrf5qO71TV75iRZDvtrGtJnlp3rMFb8TvxAlg1ugeL9yfIxoff4cuoQ5+PmCZ+JrPzFpRS7j8JGCR+JnHIaqVeDYnDQWEMP0rVOOQpTMzHjsymTLmywM6RsatnzcXElPxPoTPDiDNbyTrm4gehmrYT81kHrHIevwqreSF5aMwuY2V5hUhkvaFpS24DWpo/EHMNawc0ITy68pb/MxEbHwzOfPYOwgwYDy4ubdlWiSrs+rexbQjYPy4k75EsDEeKQRjzX6xkgiP/dw7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6524.namprd12.prod.outlook.com (2603:10b6:208:38c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 13:18:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 13:18:51 +0000
Date:   Thu, 14 Jul 2022 16:18:45 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2/net-next v2] devlink: add support for linecard
 show and type set
Message-ID: <YtAXtakVePIxAdyL@shredder>
References: <20220713134749.2988396-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713134749.2988396-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1P195CA0038.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 201dee3a-2b83-4976-57c8-08da659b64b6
X-MS-TrafficTypeDiagnostic: BL3PR12MB6524:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Zn1Y+Kr6J1XrkSwILq8slN6BUAVcPL5vaHgHYCRZ37YcCU2KqQnQkQb9cm7R4kDx1moBP1OzkrBhuPoM4Wa0g+wUA/32r63yuE6u6+eYD51HwqMV8zm7kL9uCYBoQkrj3WKBiArMkMXcFMUKfeg7LsZ76WOlR7bcHCRK99q/ncze7x3R82Miw9x87K5p/GAcdktNy6sF8QWEbHlhjxzEmVH0LUX4CBjtK35nWCCOp12C1cPtzepijUi/Oy0n5G4BuP8gqQVtzTPaxUoK8bt+QpRiyOoHmqot9Dsppg78pxZ1KakL5D8c9tTxJvImUEfuyl4Ois/OoNN1sf2wmF/3gQ8HoCIiUEUpQx7j3J9JtsFV/3udYzVNI/YGB+QQ0wVxclX4XeMZWiH3kvIp2ujsU8odEGgTmU/0vKXjFcI4Ntbp0FnSt5RCfaEdyua1U3Fnuyicjqr6sVN/iOSdt6sLC3X3TQ7c8Pe4qtDrJRDeTWxBpb/QyJOieG9pId9sgtYr+1RLoiOSYGbZYEuOheTgY9/EJKutrftM9RpMDV/qHqlwoGatAt4eaIW5t0ntVPUz07DGSVCsEp30xAZZtObTtEW4uJm0kEFCSFvfrznxGsSJqflck12pi1de5on+DRcgtOZD7cDidqiqQ9PRDPQX13WWFPmJy/lZs/qatgj4mTklKOmOb00JTAooSbxNkR3JIHdEn/HGfkGDDjwfCX/5UDdIAByQn74gt8CQizbQGPfWrJE52jNoU08ZUqaXFeGWhXe56SyZXmTot7yVP9m4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(366004)(346002)(376002)(396003)(6512007)(107886003)(26005)(186003)(38100700002)(9686003)(6506007)(86362001)(41300700001)(8936002)(33716001)(316002)(66556008)(478600001)(66946007)(6666004)(66476007)(6486002)(2906002)(6916009)(5660300002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RxXzHk6LPmu0cOFTcCfhk3B0HDJCl7jmCbh5GJV2Aek6ZThTlwlE12JH3Slf?=
 =?us-ascii?Q?8vCbLJDGJGXvl5sn89ZW6fZjjo9kh9rBmhVtCFRGcgJPzi/yYBJ1aOnJxY8z?=
 =?us-ascii?Q?UigrVA/VHFim0zSDeYsRs+GrnuQssBN1nxNVzxjwhqpo+gYkoMAxTHnhxoMS?=
 =?us-ascii?Q?Dh8wyveY7/rLmoUPFF2M9MWT8rQ13hv4uoR3zHRqyes7mHxOrb+Uzn0fGXwD?=
 =?us-ascii?Q?pIBMNnXYukaxhpAhXozoDjWkmKwFwm/vz6U+MNLWxVmZAGLe3qc/tjNgyyJC?=
 =?us-ascii?Q?G9hFpkLcnDBrJUpTegfHQpFQfJ9zRK06Xp0PPoqjjkf4cOtYFtgVEJBlf10r?=
 =?us-ascii?Q?Xqgm3H+OcrWsoy/JS0dLNSrvzhnpj4hYszF0tGgvcD+EnCq3EIO0r8vbN1gS?=
 =?us-ascii?Q?oipYM+skzK/DIUfsSBuyx4xeJCtCOZ05alro5qgS4uCwYHCrvSzxWTgVCnrA?=
 =?us-ascii?Q?Os1nkbgmfMhX2A7ODFOl/8LKRv9duNSxZYFGSRqhtTc1fa2U8vIs3yfQUrb8?=
 =?us-ascii?Q?vowg3IYWyhtsbAMUCSxeaQo8ciHTVlUJUA5cFfEpQBtnUiA8xEgtszVcsqhX?=
 =?us-ascii?Q?u/n6jxDMpyXEub6q8npxCgYwhv+PRavR93OZzlknddXLr9WDNfvYt7QvBdyM?=
 =?us-ascii?Q?q394b3URFNIuNxX6l4B+cyXujjJBLEsSje4M56cWllNmQjYqu1wiHGyj4ZTb?=
 =?us-ascii?Q?7sFf1J4wvFZ4hN3rAGVnS7kgO9s3sqs3tq6vhW0a4vE0URdGWSoeBlQn5Ka9?=
 =?us-ascii?Q?B8+zIDa8NZjwfv5E8ZSvKZQ37jumPqk8o30egA10X4JNADtmkYP2DzaONG8+?=
 =?us-ascii?Q?6DKAMQXEM+mTrBqR1++lHUrMER/aYBxdbkXDZo50e6maz8mMHZifSAqHxC9J?=
 =?us-ascii?Q?o+UC0dPU4soDRnJ22dXNsiXsbGtVqR4t09lapv9zE/mZJ08he2s3W+GAuoq0?=
 =?us-ascii?Q?8MNXAQdwLiJwFKkRIjE0dlTSCudiPbSOEkusXtBi3RG7V2LH95OBm+dJw/W/?=
 =?us-ascii?Q?EP3jcLEDQCqTvEKyQO2FrxUp44cVMhS5Xfmuv6oZdFR9UFp1LEQDZQj9KkSM?=
 =?us-ascii?Q?Cok37d7EHfrJDlzhPw4i6r9eUuhIo/a/F83A7LKl7/8nJ97fK2VDA8Ic8vyz?=
 =?us-ascii?Q?FKx10yXwGHQF4rnrhMUKYBFWrR5E8Y8hYYYtFY+nCnYfY62WRVatboJVdQOJ?=
 =?us-ascii?Q?3UzExXB4q8QSegfPPmXUpEzUwm5Q+iJMTW8P2/O6qFZ+V5/kQuPdjUofqPA6?=
 =?us-ascii?Q?sH0VQyPGiVhoI4XgoPVCqL5PwYVfj7cBzmX7UR4HhEUdwJsBtkRWjLIep5i+?=
 =?us-ascii?Q?jJ3qGTyup6tHs3/IEXj00BBtlBVpz1m2ZDdpLCsmiJfIfrqvAkrhHqD9YcFR?=
 =?us-ascii?Q?+eyiQH4fMssYvZNnUvoO+v5Le54gk/+v8Q6+AChfctTws6MsvddChAKCdCKH?=
 =?us-ascii?Q?RVtNiWfsNTV1b/LzlqvSo4nOM0/T0068LjpW7hlhGt3QHTv7/0Mt4Fi0XlT4?=
 =?us-ascii?Q?luNaok6H/s2SOLxBdHSMpzc1TuJfg4EXVUsAUOuW8kc0dQzMgd+0wEY+Ck5Z?=
 =?us-ascii?Q?EshQk5u56nCUO3ltQxGib5M3+7WffdpYNq0w7KQI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201dee3a-2b83-4976-57c8-08da659b64b6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 13:18:51.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTwOG/i6Qel9bmkJvSo70cdRwsvbjWQxZbtLqELUXZzw7D9XY8h3rN5PN+TE4HXUfM8Xpt98eMvZI1iOQUjAZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6524
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 03:47:49PM +0200, Jiri Pirko wrote:
> diff --git a/bash-completion/devlink b/bash-completion/devlink
> index 361be9feee83..45c7a8121401 100644
> --- a/bash-completion/devlink
> +++ b/bash-completion/devlink
> @@ -43,6 +43,18 @@ _devlink_direct_complete()
>                      | jq '.port as $ports | $ports | keys[] as $key
>                      | ($ports[$key].netdev // $key)')
>              ;;
> +        lc)
> +            dev=${words[3]}
> +            value=$(devlink -j lc show 2>/dev/null \
> +                    | jq ".lc[\"$dev\"]" \
> +                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)')
> +            ;;

On a system that has a devlink instance without line cards I'm getting
the following error during completion:

$ devlink lc set pci/0000:06:00.0 lc jq: error (at <stdin>:1): null (null) has no keys
jq: error (at <stdin>:1): null (null) has no keys

This fixes the issue for me and should still work on a system with line
cards (test):

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 45c7a8121401..757e03b749ce 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -47,7 +47,8 @@ _devlink_direct_complete()
             dev=${words[3]}
             value=$(devlink -j lc show 2>/dev/null \
                     | jq ".lc[\"$dev\"]" \
-                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)')
+                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)' \
+                    2>/dev/null)
             ;;
         lc_type)
             dev=${words[3]}

> +        lc_type)
> +            dev=${words[3]}
> +            lc=${words[5]}
> +            value=$(devlink lc show $dev lc $lc -j 2>/dev/null \
> +                    | jq '.[][][]["supported_types"][]')
> +            ;;
>          region)
>              value=$(devlink -j region show 2>/dev/null \
>                      | jq '.regions' | jq 'keys[]')
> @@ -395,6 +407,62 @@ _devlink_port()
>      esac
>  }
>  
> +# Completion for devlink lc set
> +_devlink_lc_set()
> +{
> +    case "$cword" in
> +        3)
> +            _devlink_direct_complete "dev"
> +            return
> +            ;;
> +        4)
> +            COMPREPLY=( $( compgen -W "lc" -- "$cur" ) )
> +            ;;
> +        5)
> +            _devlink_direct_complete "lc"
> +            ;;
> +        6)
> +            COMPREPLY=( $( compgen -W "type notype" -- "$cur" ) )
> +            return
> +            ;;
> +        7)
> +            if [[ "$prev" == "type" ]]; then
> +                _devlink_direct_complete "lc_type"
> +            fi
> +    esac
> +}
> +
> +# Completion for devlink lc show
> +_devlink_lc_show()
> +{
> +    case $cword in
> +        3)
> +            _devlink_direct_complete "dev"
> +            ;;
> +        4)
> +            COMPREPLY=( $( compgen -W "lc" -- "$cur" ) )
> +            ;;
> +        5)
> +            _devlink_direct_complete "lc"
> +            ;;
> +    esac
> +}
> +
> +# Completion for devlink lc
> +_devlink_lc()
> +{
> +    case $command in
> +        set)
> +            _devlink_lc_set
> +            return
> +            ;;
> +        show)
> +            _devlink_lc_show
> +            return
> +            ;;
> +    esac
> +}
> +
>  # Completion for devlink dpipe
>  _devlink_dpipe()
>  {
> @@ -988,6 +1056,7 @@ _devlink()
>      local object=${words[1]}
>      local command=${words[2]}
>      local pprev=${words[cword - 2]}
> +    local prev=${words[cword - 1]}
>  
>      if [[ $objects =~ $object ]]; then
>          if [[ $cword -eq 2 ]]; then
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index ddf430bbb02a..1e2cfc3d4285 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c

Code itself looks consistent with other commands

[...]

> --- /dev/null
> +++ b/man/man8/devlink-lc.8
> @@ -0,0 +1,103 @@
> +.TH DEVLINK\-LC 8 "20 Apr 2022" "iproute2" "Linux"
> +.SH NAME
> +devlink-lc \- devlink line card configuration
> +.SH SYNOPSIS
> +.sp
> +.ad l
> +.in +8
> +.ti -8
> +.B devlink
> +.RI "[ " OPTIONS " ]"
> +.B lc
> +.RI  " { " COMMAND " | "
> +.BR help " }"
> +.sp
> +
> +.ti -8
> +.IR OPTIONS " := { "
> +\fB\-V\fR[\fIersion\fR] }
> +
> +.ti -8
> +.B "devlink lc set"
> +.IB DEV " lc " LC_INDEX
> +.RB [ " type " {
> +.IR LC_TYPE " | "
> +.BR notype " } ] "
> +
> +.ti -8
> +.B "devlink lc show"
> +.RI "[ " DEV " [ "
> +.BI lc " LC_INDEX
> +.R  " ] ]"
> +
> +.ti -8
> +.B devlink lc help
> +
> +.SH "DESCRIPTION"
> +.SS devlink lc set - change line card attributes
> +
> +.PP
> +.TP
> +.I "DEV"
> +Specifies the devlink device to operate on.
> +
> +.in +4
> +Format is:
> +.in +2
> +BUS_NAME/BUS_ADDRESS
> +
> +.TP
> +.BI lc " LC_INDEX "
> +Specifies index of a line card slot to set.
> +
> +.TP
> +.BR type " { "
> +.IR LC_TYPE " | "
> +.BR notype " } "
> +Type of line card to provision. Each driver provides a list of supported line card types which is shown in the output of
> +.BR "devlink lc show " command.
> +
> +.SS devlink lc show - display line card attributes
> +
> +.PP
> +.TP
> +.I "DEV"
> +.RB "Specifies the devlink device to operate on. If this and " lc " arguments are omitted all line cards of all devices are listed.
> +
> +.TP
> +.BI lc " LC_INDEX "
> +Specifies index of a line card slot to show.
> +
> +.SH "EXAMPLES"
> +.PP
> +devlink ls show

s/ls/lc/

> +.RS 4
> +Shows the state of all line cards on the system.
> +.RE
> +.PP
> +devlink lc show pci/0000:01:00.0 lc 1
> +.RS 4
> +Shows the state of line card with index 1.
> +.RE
> +.PP
> +devlink lc set pci/0000:01:00.0 lc 1 type 16x100G
> +.RS 4
> +.RI "Set type of specified line card to type " 16x100G "."

s/Set/Sets/

Or change the first two

> +.RE
> +.PP
> +devlink lc set pci/0000:01:00.0 lc 1 notype
> +.RS 4
> +Clear provisioning on a line card.

s/Clear/Clears/

> +.RE
> +
> +.SH SEE ALSO
> +.BR devlink (8),
> +.BR devlink-dev (8),
> +.BR devlink-port (8),
> +.BR devlink-sb (8),

Irrelevant

> +.BR devlink-monitor (8),
> +.BR devlink-health (8),

Same

> +.br
> +
> +.SH AUTHOR
> +Jiri Pirko <jiri@nvidia.com>
> -- 
> 2.35.3
> 
