Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEE58F59A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 03:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiHKBlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 21:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 21:41:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C5B844FE;
        Wed, 10 Aug 2022 18:41:12 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h132so15888998pgc.10;
        Wed, 10 Aug 2022 18:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=F6hxhK/CjlN1f5v5Y2g2kDzYo8Q8zwKdylN6nrbEMvU=;
        b=ic+8ScICKjjbdXIQQQmthij281I3mSRMks3Wz+5PmPGiGjve/0Mhj6uJHW1C1OjV49
         5dhtxWSiJpNuJ4+u/PT+J4y0S29qrn/kl6QgtlDQtaFaKNXFfotD9Y5odxIsOYNxDM5l
         J7R41PfhBLdPrayfFvDdBVB2MYqh8S4DudkAVWtJcxktwa8nBrRGTaxtOaLgXThhd/hV
         Fi3Ef7T557Gx2t5tXOK/JCsboXGvZOuhthyyJj0lUtoFz9uUHYAmV+HwtDZ1Bs36IA+C
         d4R6msDSug80BQWdnojMkESuKlA0YuJAsUSJEHSAKYUFcTLZ1xbmb9xE7YFBAvkN5+VW
         H3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=F6hxhK/CjlN1f5v5Y2g2kDzYo8Q8zwKdylN6nrbEMvU=;
        b=ysum7JKUjl8pQMG+jD4rqBPW8Cjvf0WYGXJgAHuSK/dHY0lp9VtP+TpMbcdsCOf9XC
         bJzfUJZnwkkHnasDqaoBj/PDSbQrptJJiETA54speZ+bKHf3FKb2V/52M2CgG6h+gSYS
         HUieZ42CZu1AKughuUFmN6zU9hIYLprHUEhGwZQIcju/4DTTK/tBrUyCj1c0SyXk6Qmm
         UIZMUVpJigGxeb3bA17a6bhyrYEbSe9cS03FtvxO7ddP8PRRxIKz3770Yu19o9jviMek
         yLuxG64p4qZd3Lb8hOky3DDAi7xEjjJ3NfgpaPFsUX5HLsZjFb8Qf12eG/RMNDHQZj7I
         Dz4A==
X-Gm-Message-State: ACgBeo3FQy1rebjH5eR5tqmXNBnMgvhrXi2WPJ2JJ6AacHE5C2TrhcBc
        K/50VeOKIDguEr6v0phgNds=
X-Google-Smtp-Source: AA6agR5i4m+EV/NKTsVlOHb/dJE8NZ1qD2gdYXDUfRbMq2kX6GDB3kvaCOXOJmrSZhtfLN6xJuAOeA==
X-Received: by 2002:a63:8ac3:0:b0:41b:ba48:e3f6 with SMTP id y186-20020a638ac3000000b0041bba48e3f6mr24089927pgd.567.1660182072334;
        Wed, 10 Aug 2022 18:41:12 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b17-20020a621b11000000b0052da33fe7d2sm2818830pfb.95.2022.08.10.18.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 18:41:11 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:41:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Piyush Thange <pthange19@gmail.com>, davem <davem@davemloft.net>,
        edumazet <edumazet@google.com>, kuba <kuba@kernel.org>,
        pabeni <pabeni@redhat.com>, shuah <shuah@kernel.org>,
        "vladimir.oltean" <vladimir.oltean@nxp.com>,
        idosch <idosch@nvidia.com>, petrm <petrm@nvidia.com>,
        troglobit <troglobit@gmail.com>, amcohen <amcohen@nvidia.com>,
        tobias <tobias@waldekranz.com>,
        "po-hsu.lin" <po-hsu.lin@canonical.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH] selftests:net:forwarding: Included install command
Message-ID: <YvReL0HkZt639BoO@Laptop-X1>
References: <20220810093508.33790-1-pthange19@gmail.com>
 <182872c2de1.4461d55242061.8862004854197621952@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182872c2de1.4461d55242061.8862004854197621952@siddh.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:23:15PM +0530, Siddh Raman Pant wrote:
> On Wed, 10 Aug 2022 15:05:08 +0530  Piyush Thange <pthange19@gmail.com>  wrote:
> > If the execution is skipped due to "jq not installed" message then
> > the installation methods on different OS's have been provided with
> > this message.
> > 
> > Signed-off-by: Piyush Thange <pthange19@gmail.com>
> > ---
> >  tools/testing/selftests/net/forwarding/lib.sh | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
> > index 37ae49d47853..c4121856fe06 100755
> > --- a/tools/testing/selftests/net/forwarding/lib.sh
> > +++ b/tools/testing/selftests/net/forwarding/lib.sh
> > @@ -152,6 +152,14 @@ require_command()
> > 
> >  	if [[ ! -x "$(command -v "$cmd")" ]]; then
> >  		echo "SKIP: $cmd not installed"
> > +		if [[ $cmd == "jq" ]]; then
> > +			echo " Install on Debian based systems"
> > +			echo "	sudo apt -y install jq"
> > +			echo " Install on RHEL based systems"
> > +			echo "	sudo yum -y install jq"
> > +			echo " Install on Fedora based systems"
> > +			echo "	sudo dnf -y install jq"
> > +		fi
> >  		exit $ksft_skip
> >  	fi
> >  }
> > --
> > 2.37.1
> 
> This is very specific to `jq` command. What's special with `jq` and not
> others? If methods have to be shown, they should be shown for all the
> programs which are not installed.

Agree. The user could decide if jq should be install via REQUIRE_JQ. There are
also other cmds that vendor may not build by default. I didn't see any
selftests need to handle the installation. The users should takes care of it.

require_command() has takes care most of the needed cmds. If we want to
improve the user's experience for the needed cmds. I think add the needed cmds
to README file is better.

Thanks
Hangbin
