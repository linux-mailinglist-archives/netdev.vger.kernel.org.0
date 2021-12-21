Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D273547C966
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 23:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhLUWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 17:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLUWuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 17:50:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F28C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 14:50:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso3928470pjf.3
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 14:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=NxZswluoRX+ZI8aq6fWIPiuL1wxchiVZwc8+dTIgVp0=;
        b=Klk9qAaHLPeML3+Et4b1nYcqNrpqFFEqXI0G8Qmy9Z0mAk3Eq/OFFFW5OLFXw6HXL9
         UPFAR7nKcdH9GUHlZhy65pzCbD1GAjDgC4X8s2HVd4jTldwbt81lIzJUmpr0k0aeQlMN
         /qfc5c/0vLdauQ2wDjfFVn4cjkEx9AdCxy1KOpLzgUOtlP45l6I2we1hsjgTyERH+pwv
         OHVQoSixqMw9Cy1hA1mfQ3loVJdnhYwoSGzX5augR5f7C/vSfd4dZohWyMeMa/d7Zi38
         jjibs22YNJuGzifOHo+KNOJo5EBZY1hW5UpyWVHUAtMrf3DSRg2RGpiGEicf0mloc8LL
         UYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=NxZswluoRX+ZI8aq6fWIPiuL1wxchiVZwc8+dTIgVp0=;
        b=8QMJ5iwbaFuBl7tLMwZG8V9yX59Jz8+SUlvwV8fSY9HQY5jG/PvWG1qBWzes2sYON+
         IN16Cv1J9rOQgGxkX5c3gwYb4HJRdAoFAP4xy1p9rmu2vtpe086JPA88p9xOFcMQCFTv
         wxOiRnxEg+S3AS9bi9bbmE7YgoWrmtzZJfhWxJnHUYqJQCLS0OkKlMCKI4pQyf1jXFry
         Xglq7Kyjdqdrlw80ku1Y7Kwi3RGpKLLFd56qwp9nsJeOA/iKSoPHX6uqc717PZz6XdXY
         bfWcDXdrb59VuGdmxJy6rBhbO7O2YvTUMy28g8QRRxla1WMENpYz/Y+qUhYiIo+2UDM3
         D4Kw==
X-Gm-Message-State: AOAM5303eOk+dqc8/e2cQvaoQWVHpkboasDVzxSRK2Ms5bmheXPtWppN
        2nHEOKF4ikz+T24gZ9rcM7YwAg==
X-Google-Smtp-Source: ABdhPJxveFDM8k9eey/9hZKZP+GYG1ExibVwCeOy4G9h2mq8Gsb2BJChRwIKni6FWSxNuVhUQUKdTw==
X-Received: by 2002:a17:90b:19d4:: with SMTP id nm20mr669257pjb.106.1640127016721;
        Tue, 21 Dec 2021 14:50:16 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l1sm50165pgn.35.2021.12.21.14.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 14:50:16 -0800 (PST)
Date:   Tue, 21 Dec 2021 14:50:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     in Long <lucien.xin@gmail.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: SCTP ABI breakage?
Message-ID: <20211221145013.767d833b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like changes to SCTP events create kernel ABI breakage in applications.

If application is compiled with new header but attempts to run on older kernel, it doesn't work:

Reported here: https://osmocom.org/issues/5366

Looks like bad design assumptions about how setsockopt here:
static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
				  unsigned int optlen)
{
	struct sctp_sock *sp = sctp_sk(sk);
	struct sctp_association *asoc;
	int i;

	if (optlen > sizeof(struct sctp_event_subscribe))
		return -EINVAL;

Because of that the commits that add new events cause code built with the new
header to not run on older kernels.
