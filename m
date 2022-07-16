Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBC576D73
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiGPLXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGPLXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:23:10 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F42B1F2E0
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:23:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so4502015wmb.5
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tachBHEcObPRxKw40JGgy7nkfkrQgdN1l57Ep4aOUwM=;
        b=VQQghi8MFOJX2mQHedzXPQySDOT6HolW6guohsX8G0u3kRDJ6Imkq4rkM9sDhZjFF6
         EK6ng0lNNY6w5Rb2B48An4Rzigg9WTdfIMe6l3rl+zvPBdb5NtH2uAOAznXvTnXv8zGA
         SYelOCLmlBUYc/NNwijrCOkBpQtnyw1Ue8z+ekXlLuhE3c7mBsSVg+cPeFXyRcVCcdfO
         7hug9o6z1D2D4oKP6CUqPoYkGHdpPi4EcYvQjSx78Ld8shUiqSgh6CeS+Z2zejxIijYB
         RgWGBekwAEWH+Mooq+NtbBFVM+kKQUduAr1UJIXM1THUis7gxRTdRo2DT1RivGHg8Gsg
         U2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tachBHEcObPRxKw40JGgy7nkfkrQgdN1l57Ep4aOUwM=;
        b=pJQkoBxN1dUrQBs9ppJETzBFR8nb6qkHb3K/wo3LhKvMHSerk/l4uGX+1pygiS3Mk/
         17uAvGBs2Dm4ARXZ1zcGde1OoTUH2ZGcp/mjyu4l8yZHWsrZWkXIwJKR3rHk9VfKMNHa
         5G4SEhZJe2t51ZvaNmF0/0QJUmN6gmuHdxjEvr2NednVVe0QaeTJA6GqbsuZ4QT+AXm6
         EgMU54NDmlDqHeKhCb4jjUoz/IgFQZir49jkf2acWZfMQvHFuFICKw3bnZ2u3qmZuKGi
         Ko77SG5oYImzEMs2eGlAGNbXxVLUfeHS2K/ioJDo++tIbwJbcKkVTR2M3unfbuHwB2jR
         znrw==
X-Gm-Message-State: AJIora+v/1wtjz8UZYX31hwk3UgPmjZ2wZ0urXP1EkI3+5FkGT5TL+hI
        vpe+s5YiUZkoXiU0eZelCMqeCg==
X-Google-Smtp-Source: AGRyM1vJ9OZG9rJLu1DhMEg8KFUJST7Ll+ZvVvR9yS1weyxdHnN04up9Ondr4RXlKE1T0t1QzfVaIg==
X-Received: by 2002:a05:600c:1e04:b0:3a3:11ca:5c0c with SMTP id ay4-20020a05600c1e0400b003a311ca5c0cmr2762794wmb.31.1657970588017;
        Sat, 16 Jul 2022 04:23:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c4f9200b003a2ec73887fsm16035688wmq.1.2022.07.16.04.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:23:07 -0700 (PDT)
Date:   Sat, 16 Jul 2022 13:23:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2/net-next v2] devlink: add support for linecard
 show and type set
Message-ID: <YtKfmjFx7df2fckB@nanopsycho>
References: <20220713134749.2988396-1-jiri@resnulli.us>
 <YtAXtakVePIxAdyL@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtAXtakVePIxAdyL@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 14, 2022 at 03:18:45PM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 13, 2022 at 03:47:49PM +0200, Jiri Pirko wrote:
>> diff --git a/bash-completion/devlink b/bash-completion/devlink
>> index 361be9feee83..45c7a8121401 100644
>> --- a/bash-completion/devlink
>> +++ b/bash-completion/devlink
>> @@ -43,6 +43,18 @@ _devlink_direct_complete()
>>                      | jq '.port as $ports | $ports | keys[] as $key
>>                      | ($ports[$key].netdev // $key)')
>>              ;;
>> +        lc)
>> +            dev=${words[3]}
>> +            value=$(devlink -j lc show 2>/dev/null \
>> +                    | jq ".lc[\"$dev\"]" \
>> +                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)')
>> +            ;;
>
>On a system that has a devlink instance without line cards I'm getting
>the following error during completion:
>
>$ devlink lc set pci/0000:06:00.0 lc jq: error (at <stdin>:1): null (null) has no keys
>jq: error (at <stdin>:1): null (null) has no keys
>
>This fixes the issue for me and should still work on a system with line
>cards (test):

Okay. Thanks.


>
>diff --git a/bash-completion/devlink b/bash-completion/devlink
>index 45c7a8121401..757e03b749ce 100644
>--- a/bash-completion/devlink
>+++ b/bash-completion/devlink
>@@ -47,7 +47,8 @@ _devlink_direct_complete()
>             dev=${words[3]}
>             value=$(devlink -j lc show 2>/dev/null \
>                     | jq ".lc[\"$dev\"]" \
>-                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)')
>+                    | jq '. as $lcs | $lcs | keys[] as $key |($lcs[$key].lc)' \
>+                    2>/dev/null)
>             ;;
>         lc_type)
>             dev=${words[3]}
>
>> +        lc_type)
>> +            dev=${words[3]}
>> +            lc=${words[5]}
>> +            value=$(devlink lc show $dev lc $lc -j 2>/dev/null \
>> +                    | jq '.[][][]["supported_types"][]')
>> +            ;;
>>          region)
>>              value=$(devlink -j region show 2>/dev/null \
>>                      | jq '.regions' | jq 'keys[]')
>> @@ -395,6 +407,62 @@ _devlink_port()
>>      esac
>>  }
>>  
>> +# Completion for devlink lc set
>> +_devlink_lc_set()
>> +{
>> +    case "$cword" in
>> +        3)
>> +            _devlink_direct_complete "dev"
>> +            return
>> +            ;;
>> +        4)
>> +            COMPREPLY=( $( compgen -W "lc" -- "$cur" ) )
>> +            ;;
>> +        5)
>> +            _devlink_direct_complete "lc"
>> +            ;;
>> +        6)
>> +            COMPREPLY=( $( compgen -W "type notype" -- "$cur" ) )
>> +            return
>> +            ;;
>> +        7)
>> +            if [[ "$prev" == "type" ]]; then
>> +                _devlink_direct_complete "lc_type"
>> +            fi
>> +    esac
>> +}
>> +
>> +# Completion for devlink lc show
>> +_devlink_lc_show()
>> +{
>> +    case $cword in
>> +        3)
>> +            _devlink_direct_complete "dev"
>> +            ;;
>> +        4)
>> +            COMPREPLY=( $( compgen -W "lc" -- "$cur" ) )
>> +            ;;
>> +        5)
>> +            _devlink_direct_complete "lc"
>> +            ;;
>> +    esac
>> +}
>> +
>> +# Completion for devlink lc
>> +_devlink_lc()
>> +{
>> +    case $command in
>> +        set)
>> +            _devlink_lc_set
>> +            return
>> +            ;;
>> +        show)
>> +            _devlink_lc_show
>> +            return
>> +            ;;
>> +    esac
>> +}
>> +
>>  # Completion for devlink dpipe
>>  _devlink_dpipe()
>>  {
>> @@ -988,6 +1056,7 @@ _devlink()
>>      local object=${words[1]}
>>      local command=${words[2]}
>>      local pprev=${words[cword - 2]}
>> +    local prev=${words[cword - 1]}
>>  
>>      if [[ $objects =~ $object ]]; then
>>          if [[ $cword -eq 2 ]]; then
>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index ddf430bbb02a..1e2cfc3d4285 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>
>Code itself looks consistent with other commands

Good.


>
>[...]
>
>> --- /dev/null
>> +++ b/man/man8/devlink-lc.8
>> @@ -0,0 +1,103 @@
>> +.TH DEVLINK\-LC 8 "20 Apr 2022" "iproute2" "Linux"
>> +.SH NAME
>> +devlink-lc \- devlink line card configuration
>> +.SH SYNOPSIS
>> +.sp
>> +.ad l
>> +.in +8
>> +.ti -8
>> +.B devlink
>> +.RI "[ " OPTIONS " ]"
>> +.B lc
>> +.RI  " { " COMMAND " | "
>> +.BR help " }"
>> +.sp
>> +
>> +.ti -8
>> +.IR OPTIONS " := { "
>> +\fB\-V\fR[\fIersion\fR] }
>> +
>> +.ti -8
>> +.B "devlink lc set"
>> +.IB DEV " lc " LC_INDEX
>> +.RB [ " type " {
>> +.IR LC_TYPE " | "
>> +.BR notype " } ] "
>> +
>> +.ti -8
>> +.B "devlink lc show"
>> +.RI "[ " DEV " [ "
>> +.BI lc " LC_INDEX
>> +.R  " ] ]"
>> +
>> +.ti -8
>> +.B devlink lc help
>> +
>> +.SH "DESCRIPTION"
>> +.SS devlink lc set - change line card attributes
>> +
>> +.PP
>> +.TP
>> +.I "DEV"
>> +Specifies the devlink device to operate on.
>> +
>> +.in +4
>> +Format is:
>> +.in +2
>> +BUS_NAME/BUS_ADDRESS
>> +
>> +.TP
>> +.BI lc " LC_INDEX "
>> +Specifies index of a line card slot to set.
>> +
>> +.TP
>> +.BR type " { "
>> +.IR LC_TYPE " | "
>> +.BR notype " } "
>> +Type of line card to provision. Each driver provides a list of supported line card types which is shown in the output of
>> +.BR "devlink lc show " command.
>> +
>> +.SS devlink lc show - display line card attributes
>> +
>> +.PP
>> +.TP
>> +.I "DEV"
>> +.RB "Specifies the devlink device to operate on. If this and " lc " arguments are omitted all line cards of all devices are listed.
>> +
>> +.TP
>> +.BI lc " LC_INDEX "
>> +Specifies index of a line card slot to show.
>> +
>> +.SH "EXAMPLES"
>> +.PP
>> +devlink ls show
>
>s/ls/lc/

Fixed.


>
>> +.RS 4
>> +Shows the state of all line cards on the system.
>> +.RE
>> +.PP
>> +devlink lc show pci/0000:01:00.0 lc 1
>> +.RS 4
>> +Shows the state of line card with index 1.
>> +.RE
>> +.PP
>> +devlink lc set pci/0000:01:00.0 lc 1 type 16x100G
>> +.RS 4
>> +.RI "Set type of specified line card to type " 16x100G "."
>
>s/Set/Sets/

Fixed.


>
>Or change the first two
>
>> +.RE
>> +.PP
>> +devlink lc set pci/0000:01:00.0 lc 1 notype
>> +.RS 4
>> +Clear provisioning on a line card.
>
>s/Clear/Clears/

Fixed.


>
>> +.RE
>> +
>> +.SH SEE ALSO
>> +.BR devlink (8),
>> +.BR devlink-dev (8),
>> +.BR devlink-port (8),
>> +.BR devlink-sb (8),
>
>Irrelevant

Fixed.


>
>> +.BR devlink-monitor (8),
>> +.BR devlink-health (8),
>
>Same

Fixed.


Thanks!

>
>> +.br
>> +
>> +.SH AUTHOR
>> +Jiri Pirko <jiri@nvidia.com>
>> -- 
>> 2.35.3
>> 
