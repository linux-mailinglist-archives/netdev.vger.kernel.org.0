Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E16BC555
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCPEkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCPEko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E3226867
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1C70B81FCA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473E3C433D2;
        Thu, 16 Mar 2023 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941609;
        bh=q+narCCi14LhlmB/S3z7Dij5voQxhVUUoncr8Q5mbS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qBZitroLvxgi7/TK0sUZ/xzfnpZq9l7YUubzeLc3YrK6OjaVXYsiqaobc6CDgMpaC
         JllJQQmohygHDGkJDklVvCoE7U2KYBchA3inhjrwuhbxCQXN77YeiTfkx0jncpAFMb
         M7TVS7PA9o1vj8i+FoGpRZkCVBKASTmSzo8e6Q+GUh29pJcZqGseWIi0OFCYXEldUM
         1zV7eqVNDRDh06fK7aB9dyE2QPBSJSonY2YHiEcgWhmqKTNkAXMjVvUH15FupeIh4o
         vr7xuaruA6iaTCzG6ZX6Io9D3QYAR1NZjw+kme9BbEWSSMpeP40HhynHtLxOGRwOFX
         dmjp/jm8OmReQ==
Date:   Wed, 15 Mar 2023 21:40:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com
Subject: Re: [PATCH net] tools: ynl: add the Python requirements.txt file
Message-ID: <20230315214008.2536a1b4@kernel.org>
In-Reply-To: <20230314160758.23719-1-michal.michalik@intel.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 17:07:58 +0100 Michal Michalik wrote:
> It is a good practice to state explicitely which are the required Python
> packages needed in a particular project to run it. The most commonly
> used way is to store them in the `requirements.txt` file*.
> 
> *URL: https://pip.pypa.io/en/stable/reference/requirements-file-format/
> 
> Currently user needs to figure out himself that Python needs `PyYAML`
> and `jsonschema` (and theirs requirements) packages to use the tool.
> Add the `requirements.txt` for user convenience.
> 
> How to use it:
> 1) (optional) Create and activate empty virtual environment:
>   python3.X -m venv venv3X
>   source ./venv3X/bin/activate
> 2) Install all the required packages:
>   pip install -r requirements.txt
>     or
>   python -m pip install -r requirements.txt
> 3) Run the script!
> 
> The `requirements.txt` file was tested for:
> * Python 3.6
> * Python 3.8
> * Python 3.10

Is this very useful? IDK much about python, I'm trying to use only
packages which are commonly installed on Linux systems. jsonschema
is an exception, so I've added the --no-schema option to cli.py to
avoid it.

> diff --git a/tools/net/ynl/requirements.txt b/tools/net/ynl/requirements.txt
> new file mode 100644
> index 0000000..2ad25d9
> --- /dev/null
> +++ b/tools/net/ynl/requirements.txt
> @@ -0,0 +1,7 @@
> +attrs==22.2.0
> +importlib-metadata==4.8.3
> +jsonschema==4.0.0
> +pyrsistent==0.18.0
> +PyYAML==6.0
> +typing-extensions==4.1.1
> +zipp==3.6.0

Why the == signs? Do we care about the version of any of these?
Also, there's a lot more stuff here than I thought I'm using.
What's zipp and why typing? Did I type something and forgot? :S
