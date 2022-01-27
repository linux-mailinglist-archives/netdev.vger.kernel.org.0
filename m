Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC66D49E899
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiA0RNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiA0RNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:13:38 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323C5C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:13:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id e16so2796917pgn.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vN1jBuZFCJYHW+QYvFNnWF46fHe9jCdfLl1SBKs0p3U=;
        b=hc8tKTSPw3UdOFEpxLJmhWcb7PMjPWTfJwOoDCgIyG21uY3lyVeLZKNZ5UoIzELvo4
         SOV8FmdNJoTbrfxxkI5QWfVXL/xGYrj1MzmLRhrlr0rczyv6Gz5X82VmYrg2r2QgrU/I
         2l+ffOLyV+nB0ALLm0A5gJDmxA8WgXCED+wxGGzu4nPLdQFd0lLz7MNYX59ACniBrEzU
         SfDKquZbzsKpxcmVz/BgnJD/gJjTUGPQvJdyCsOMJJxDHTRgAWr8X5+W6UX/OfpsVOoY
         nTHoa1aCTpEhs2gqzhjSgcmEQOUmsFwak1MAX4h+VqkeOgVDFUax+YLUQYcQYR9LX2u7
         FYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vN1jBuZFCJYHW+QYvFNnWF46fHe9jCdfLl1SBKs0p3U=;
        b=j9uSUEwn1CvGtor/jXWqwT+xXFpoHQk0JD4pS6ohTaNXK5RwKnJYKeG0mMSP7hgrPO
         SlvJ1fxvktNjdzhVJSxMWq0PP5yKART5I3lzrznRzst/QlLdkkxDSq5JefUWD10Qq6Zz
         D+CEz0vx8AfUMqsxkxyNLbd9lVpPNm2dOw6AFsETcVg7fNjEwiyCjCsMIxXdSt8/XQyi
         jUxsiiorl+Td0qQ30S2LoUQt1kM93LKSEGL9/4Wde9yNr5WnxLqZh5B4B87Czcdmx+qu
         anHhNFq1qeZbA/kE38gOruKyyjDVSj8mCJUo6OSWJWt2NoO7VGgZwjO1L2EY14aJ6fEZ
         liBg==
X-Gm-Message-State: AOAM5314iUtcAboFvmURP6z1vSDZAVCBzyVTdNR6Aq2K9EySa5RAB5p0
        A+hKHCPdy8K1g8Dv8wOHYORJlA==
X-Google-Smtp-Source: ABdhPJwz8NGmu/bCo5Xvpqxf3k1L4HS6AIpnaQr87BSvF73V77L7GvMTKkC7oeEyW94tcC1xjvVE9A==
X-Received: by 2002:a05:6a00:1143:: with SMTP id b3mr3640098pfm.11.1643303617716;
        Thu, 27 Jan 2022 09:13:37 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id r12sm16738899pgn.6.2022.01.27.09.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:13:37 -0800 (PST)
Date:   Thu, 27 Jan 2022 09:13:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Message-ID: <20220127091335.410d9edd@hermes.local>
In-Reply-To: <20220127131355.126824-2-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 14:13:54 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> +		if (role == GTP_ROLE_SGSN)
> +			print_string(PRINT_ANY, "role", "role %s ", "sgsn");
> +		else
> +			print_string(PRINT_ANY, "role", "role %s ", "ggsn");

Why not us trigraph?
		print_string(PRINT_ANY, "role", "role %s ",
				role == GTP_ROLE_SGSN ? "sgsn" : "ggsn");
