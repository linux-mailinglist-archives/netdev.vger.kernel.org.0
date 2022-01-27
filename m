Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806D449E8A4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbiA0RPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiA0RPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:15:44 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F19EC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:15:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i65so3210485pfc.9
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8SYmZfswSkV6VZyicGYtmNnd8KoxIDfUK8b2E0cdXTM=;
        b=XMqloAjc2WJhOIXB4GEISNOPMx2Mi4FN02/O6pyzKPL2H99D+1PPEqEYRNdNQKHJvv
         i35eDYKuLG4gh/AOhwWSYEtwxxW+xqgNQCBgHpM8gqNSfG7vHuBDGjznVo2lK5h0JR6J
         GdPjNPTiU6YjPcUP5MERz1jpOhwm5r+Tcd8WlI60gJ/USwuxSaAjJH+uafZEKKWWWVfE
         1/86tbrX2TYIKg/zBo9U2aJTFVuS1K47H/gHieW+Cc1hE1R3GDR/3ParQsvF3dCE/0R5
         KaJ78Dibw3EvILkvUReznRIqgFu4H0ORsiH+s1WZVvEUR7NUw9BPjuEAx23+gkirgw3t
         XnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8SYmZfswSkV6VZyicGYtmNnd8KoxIDfUK8b2E0cdXTM=;
        b=QgmJ07XjUzC6/3zkzfrtykB7Z8EcX5fzB8/x9vSC9HJaKqzQzpFQXRoCVOAEZPC3J/
         aJCDctaATiW0ZQEnyD4yLaBglUvTahZUyeuvdjWakn9R2sUXxPN3CYr8l1sVfDJWxvB1
         FMnt6bI3MEjmI4RiK67ItReJ5j1b0YwbhkCJvzwGodmO+4fDZSpBhPyXvwwc7/24Awei
         p04PZi3f/gRDcLV5PiiI1V6fPrG6M0t3KUgqwM+tQZ5z/oixXMEVW8cyGv+DJPIvNrb1
         9HPvLRJw8pIkqN4GP1v/Vp4NzeyO+O/kEu5Ht0i4KTb1lv2wmoZOlHJOAqeslADksXyM
         LXTw==
X-Gm-Message-State: AOAM531WPC+O8SVoWP79vQJqo54KEEDAX/IMcBiRYt7Iot3OZ89AqNci
        heP8g+ZZRnKT4Ln+oIFJEp0loDBbtbcHoQ==
X-Google-Smtp-Source: ABdhPJz0IqPkvPs1T6AFayCze352KgTXRrJvVV+Q2vfbuZfTQjKP/D/hNbf7RAIoAjV5QMYVfg26bQ==
X-Received: by 2002:a63:f650:: with SMTP id u16mr3441156pgj.2.1643303743981;
        Thu, 27 Jan 2022 09:15:43 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c20sm5860811pfn.190.2022.01.27.09.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:15:43 -0800 (PST)
Date:   Thu, 27 Jan 2022 09:15:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next 2/2] f_flower: Implement gtp options
 support
Message-ID: <20220127091541.6667d4d1@hermes.local>
In-Reply-To: <20220127131355.126824-3-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 14:13:55 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> +	open_json_array(PRINT_JSON, name);
> +	open_json_object(NULL);
> +	print_uint(PRINT_JSON, "pdu_type", NULL, pdu_type);
> +	print_uint(PRINT_JSON, "qfi", NULL, qfi);
> +	close_json_object();
> +	close_json_array(PRINT_JSON, name);
> +
> +	sprintf(strbuf, "%02x:%02x", pdu_type, qfi);

Doing JSON specific code is not necessary here?
And why an array of two named elements? Seems confusing
