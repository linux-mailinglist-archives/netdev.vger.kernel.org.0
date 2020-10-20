Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C71294413
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 22:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405301AbgJTUoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 16:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405230AbgJTUon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 16:44:43 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BC0C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:44:43 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CG5GH25WnzQjbS;
        Tue, 20 Oct 2020 22:44:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603226677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yf8zwfdC3+DA6LJijZRwwBBNoteSO9ArZ3j38QrYass=;
        b=vAPg+jfbQ5UQVUWeO8oWQIghToUo7NK3PEAIKg4ZaUmfCVsPvT1+3zNtFt4Ejkle+aMUyD
        AyCQWdrBoK6md9zjKDa30mrZY5DFJzFB9Ly7AK2Jmhr/WGdJx9rAvm3MCP1j66yGaJKKqd
        +ON5q5yLP6Md+FR9yNcuCHpmVxa8HpzvyRF8fRW4zRa67Ejvox2f0/aYVF1kz5MOSgB87Q
        ubxP4u7I+mpB83Rw+0kZDpdCO0zY2TN+jgBEIA+wuyxapl1qvSQFPPR8VeblNJxU1uoB0E
        ZLaqmamCf63R395jeB9lUM8NIZ8MFZWanLKPmGRo8vk9jHyZ7+rn/ae6p7U+Jw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id suvlA1xXPAB4; Tue, 20 Oct 2020 22:44:33 +0200 (CEST)
References: <cover.1603154867.git.me@pmachata.org> <233147e872018f538306e5f8dad3f3be07540d81.1603154867.git.me@pmachata.org> <851rht9loc.fsf@mojatatu.com>
From:   Petr Machata <me@pmachata.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 11/15] lib: Extract from iplink_vlan a helper to parse key:value arrays
In-reply-to: <851rht9loc.fsf@mojatatu.com>
Date:   Tue, 20 Oct 2020 22:44:31 +0200
Message-ID: <875z74k4pc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.62 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3FE291704
X-Rspamd-UID: f8ae4a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roman Mashak <mrv@mojatatu.com> writes:

> Petr Machata <me@pmachata.org> writes:
>
>
> [...]
>
>> +static int parse_qos_mapping(__u32 key, char *value, void *data)
>> +{
>> +	struct nlmsghdr *n = data;
>> +	struct ifla_vlan_qos_mapping m = {
>> +		.from = key,
>> +	};
>> +
>> +	if (get_u32(&m.to, value, 0))
>> +		return 1;
>> +
>> +	addattr_l(n, 1024, IFLA_VLAN_QOS_MAPPING, &m, sizeof(m));
>> +	return 0;
>> +}
>
> addatr_l() may fail if netlink buffer size is not sufficient, may be:
>
> return addattr_l(...);
>
> would be better.

Ack, makes sense to fix this since I'm moving the code around anyway.
