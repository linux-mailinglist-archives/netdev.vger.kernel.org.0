Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C86B2764E9
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIXAMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:12:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:47865 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgIXAMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 20:12:02 -0400
IronPort-SDR: vA6fTn4obErbQhIqzDg92sRPUEsWDGxLJVpHsEK2jzfuPoHNDvTufx8fjo7PuvuUPyTKtwRjwB
 PKECWbVjjvFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="141056817"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="141056817"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 17:12:02 -0700
IronPort-SDR: 7JfZCxuOW/DI12yjLp2pI8z+vQLV7lnQEcAg0pcWBzJgQmA2yA9gyLoQGeRCkUoKEfAb9XX5h6
 f9+CHKRNjfIg==
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="290976507"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.23.95]) ([10.212.23.95])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 17:12:01 -0700
Subject: Re: [PATCH ethtool-next 3/5] separate FLAGS out in -h
To:     Jakub Kicinski <kuba@kernel.org>, mkubecek@suse.cz
Cc:     netdev@vger.kernel.org
References: <20200915235259.457050-1-kuba@kernel.org>
 <20200915235259.457050-4-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <31713271-964d-42cb-9d27-2e111c818a12@intel.com>
Date:   Wed, 23 Sep 2020 17:12:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200915235259.457050-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2020 4:52 PM, Jakub Kicinski wrote:
> Help output is quite crowded already with every command
> being prefixed by --debug and --json options, and we're
> about to add a third one.
> 
> Add an indirection.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Seems reasonable to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  ethtool.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 23ecfcfd069c..ae5310e9e306 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5947,10 +5947,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
>  	fprintf(stdout, PACKAGE " version " VERSION "\n");
>  	fprintf(stdout,
>  		"Usage:\n"
> -		"        ethtool [ --debug MASK ][ --json ] DEVNAME\t"
> +		"        ethtool [ FLAGS ] DEVNAME\t"
>  		"Display standard information about device\n");
>  	for (i = 0; args[i].opts; i++) {
> -		fputs("        ethtool [ --debug MASK ][ --json ] ", stdout);
> +		fputs("        ethtool [ FLAGS ] ", stdout);
>  		fprintf(stdout, "%s %s\t%s\n",
>  			args[i].opts,
>  			args[i].no_dev ? "\t" : "DEVNAME",
> @@ -5959,7 +5959,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
>  			fputs(args[i].xhelp, stdout);
>  	}
>  	nl_monitor_usage();
> -	fprintf(stdout, "Not all options support JSON output\n");
> +	fprintf(stdout, "\n");
> +	fprintf(stdout, "FLAGS:\n");
> +	fprintf(stdout, "	--debug MASK	turn on debugging messages\n");
> +	fprintf(stdout, "	--json		enable JSON output format (not supported by all commands)\n");
>  

Not really related to this patch, but what is the behavior of a command
when --json is used but it doesn't support it?

Thanks,
Jake

>  	return 0;
>  }
> 
