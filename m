Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4881238A3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfLQVZh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Dec 2019 16:25:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:17034 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfLQVZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:25:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:25:37 -0800
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="221846945"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.170])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:25:37 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] taprio: Add support for the SetAndHold and SetAndRelease commands
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        David Ahern <dsahern@gmail.com>
Message-ID: <157661793667.26178.2900020767109305347@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Tue, 17 Dec 2019 13:25:36 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

Quoting Jose Abreu (2019-12-17 06:10:24)
> Although this is already in kernel, currently the tool does not support
> them. We need these commands for full TSN features which are currently
> supported in Synopsys IPs such as QoS and XGMAC3.
> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> ---
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tc/q_taprio.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tc/q_taprio.c b/tc/q_taprio.c
> index b9954436b0f9..62ff860e80ae 100644
> --- a/tc/q_taprio.c
> +++ b/tc/q_taprio.c
> @@ -99,6 +99,10 @@ static const char *entry_cmd_to_str(__u8 cmd)
>         switch (cmd) {
>         case TC_TAPRIO_CMD_SET_GATES:
>                 return "S";
> +       case TC_TAPRIO_CMD_SET_AND_HOLD:
> +               return "H";
> +       case TC_TAPRIO_CMD_SET_AND_RELEASE:
> +               return "R";
>         default:
>                 return "Invalid";
>         }
> @@ -108,6 +112,10 @@ static int str_to_entry_cmd(const char *str)
>  {
>         if (strcmp(str, "S") == 0)
>                 return TC_TAPRIO_CMD_SET_GATES;
> +       if (strcmp(str, "H") == 0)
> +               return TC_TAPRIO_CMD_SET_AND_HOLD;
> +       if (strcmp(str, "R") == 0)
> +               return TC_TAPRIO_CMD_SET_AND_RELEASE;
>  
>         return -1;
>  }

From the commit message, I had the impression that HOLD and RELEASE commands
are supported by QoS and XGMAC3. However, in '[PATCH net-next v2 7/7] net:
stmmac: Integrate EST with TAPRIO scheduler API' I see:

+               if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+                       return -EOPNOTSUPP;

Am I missing something or these commands are indeed not supported by Synopsys
IPs?

Anyhow, this patch makes sense to me.

Regards,

Andre
