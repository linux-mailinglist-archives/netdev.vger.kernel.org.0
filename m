Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C132E58EA16
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiHJJyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiHJJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:54:23 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F5A6D555;
        Wed, 10 Aug 2022 02:54:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660125207; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=UblMjqw8qmPYogTQo3ltSXOQI+8glvR4lqIxjVk9CzooC8iZYsOgp40duR8QENbGEW40NR0sowLV5c0W9DYuSO+pu3d7pwwHdzxFPTfI89v9AYHUrDFUdMnRC8CcwgDbx23R9fYrba6Elf/JRCjHWWJZM4wRVr3GyuSe7vf6NqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660125207; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=jFHeqsb5u9GbFqhnxEh8/I0ZWgirYI4r/VF0zXwQCKg=; 
        b=Y45gDrz/+voF4praet59up2VOlOoGeXzgZ1/SGYannQc77KA7wAOT5YxVU+Rd9OvlifALZMlkuJjFg8WR0bqDqJw9HKYbHPHa8Jq4VO3YAOkhCwawCAQvJ0A01xNcB8NreI18yUGdfHhTve7Q1N9nOy33LKNCXRf3okVMO1i1Mw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660125207;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=jFHeqsb5u9GbFqhnxEh8/I0ZWgirYI4r/VF0zXwQCKg=;
        b=EO6t/NXZcel9fZsbNJY0cIuSsZPbL5sJaTI4e5p6BpXc38Zv6a95Dr850rfR4QLl
        9ychbWnlk/OBS3tjW9tHDqWJ2XafJTl25LMDMwBDzx4L53TP5wB1et80vPJ9Av8GJmN
        bMXBvyywSJwtqzwGd+4jdvk449o11kXMCIzcUrtg=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660125195772428.3384944175755; Wed, 10 Aug 2022 15:23:15 +0530 (IST)
Date:   Wed, 10 Aug 2022 15:23:15 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Piyush Thange" <pthange19@gmail.com>
Cc:     "davem" <davem@davemloft.net>, "edumazet" <edumazet@google.com>,
        "kuba" <kuba@kernel.org>, "pabeni" <pabeni@redhat.com>,
        "shuah" <shuah@kernel.org>,
        "vladimir.oltean" <vladimir.oltean@nxp.com>,
        "idosch" <idosch@nvidia.com>, "petrm" <petrm@nvidia.com>,
        "troglobit" <troglobit@gmail.com>, "amcohen" <amcohen@nvidia.com>,
        "tobias" <tobias@waldekranz.com>,
        "po-hsu.lin" <po-hsu.lin@canonical.com>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kselftest" <linux-kselftest@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <182872c2de1.4461d55242061.8862004854197621952@siddh.me>
In-Reply-To: <20220810093508.33790-1-pthange19@gmail.com>
References: <20220810093508.33790-1-pthange19@gmail.com>
Subject: Re: [PATCH] selftests:net:forwarding: Included install command
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 15:05:08 +0530  Piyush Thange <pthange19@gmail.com>  wrote:
> If the execution is skipped due to "jq not installed" message then
> the installation methods on different OS's have been provided with
> this message.
> 
> Signed-off-by: Piyush Thange <pthange19@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
> index 37ae49d47853..c4121856fe06 100755
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -152,6 +152,14 @@ require_command()
> 
>  	if [[ ! -x "$(command -v "$cmd")" ]]; then
>  		echo "SKIP: $cmd not installed"
> +		if [[ $cmd == "jq" ]]; then
> +			echo " Install on Debian based systems"
> +			echo "	sudo apt -y install jq"
> +			echo " Install on RHEL based systems"
> +			echo "	sudo yum -y install jq"
> +			echo " Install on Fedora based systems"
> +			echo "	sudo dnf -y install jq"
> +		fi
>  		exit $ksft_skip
>  	fi
>  }
> --
> 2.37.1

This is very specific to `jq` command. What's special with `jq` and not
others? If methods have to be shown, they should be shown for all the
programs which are not installed.

Further, this limits the information to specific package managers and
systems in the userspace. Tomorrow a new system may come, which will
cause this list to grow, not to mention other existing package managers.
The kernel also doesn't have a role in it, so we should try to be generic
as much as possible.

Thanks,
Siddh
