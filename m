Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BA82F2DF8
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbhALLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:34:10 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:25620 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbhALLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 06:34:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610451228; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=PwKYlg6+zfHY5jZuggieGsUBveo3C3f0CdcDg4Doxeo=; b=AX3SOda6KN9/t/s7hgFO1nxLCl0ORAgfTZBbYusNjPPT3X2iZr9Q7/3KDUitg2cLtlTCP7QY
 0cEU3oCvyN5IVtGv6eJUxWfyC9TQg2tH8Lbf5W68CLfaUAjjrWUNeEqfrGW9WKfniKYQ1Xey
 jLdPQJINWUbEn6LUeyLtwD0IvYI=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5ffd8902c88af0610730eb8f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 11:33:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 15700C433C6; Tue, 12 Jan 2021 11:33:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD082C433C6;
        Tue, 12 Jan 2021 11:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD082C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Arjen de Korte <suse+build@de-korte.org>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: regression in iwlwifi: page fault in iwl_dbg_tlv_alloc_region() (commit ba8f6f4ae254)
References: <20201228115814.GA5880@lion.mk-sys.cz>
Date:   Tue, 12 Jan 2021 13:33:14 +0200
In-Reply-To: <20201228115814.GA5880@lion.mk-sys.cz> (Michal Kubecek's message
        of "Mon, 28 Dec 2020 12:58:14 +0100")
Message-ID: <87v9c2qtj9.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding luca)

Michal Kubecek <mkubecek@suse.cz> writes:

> FYI, there is a regression in iwlwifi driver caused by commit
> ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")
> reported at
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=210733
>   https://bugzilla.suse.com/show_bug.cgi?id=1180344
>
> The problem seems to be an attempt to write terminating null character
> into a string which may be read only. There is also a proposed fix.

Can someone submit a proper patch, please? See instructions below how to
submit.

And please add Fixes tag to the commit log:

Fixes: ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
