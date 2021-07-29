Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97D83DA097
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 11:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhG2Jvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 05:51:41 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52759 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhG2Jvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 05:51:40 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id C2588200E1C2;
        Thu, 29 Jul 2021 11:51:35 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C2588200E1C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627552295;
        bh=+8w+mDWK3OhlOmKgdUFqwOzt0S1XnsLyxy6XAk40ApU=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=vS58GnzwjLmulET9kQKSP4ZbafwMl5aqKooF+eAkqvnJ1ZrW3oRv+95Chf6iWwcnL
         QxbLyyyQiY/51E2PdAc9mZ3xXAEan5qsa+l6gxj44219FN7/R5tjEdZQgUag+rXej+
         y6ZY+hPp5KaCJWWG8xLtsnalT7GZFlyo+e6ggnheqiYr7dhrovJWsCwqNNFfvqT8Oc
         M26pcu+DbTHucLpjVfk29azH43rlsQUXA/tsPxc6/RJMgvyD0zcu6HqbsOgde8P+PY
         rQBB9dOAsQJzIl+RgyjrBVibHwo8bP5N5KhxcJf/YSk/Pymtnh4cJJGeGaaTgg8qeg
         2lGUszuPs/Xxg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BA7156008D510;
        Thu, 29 Jul 2021 11:51:35 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qk6LcQ0kL-At; Thu, 29 Jul 2021 11:51:35 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A159860082323;
        Thu, 29 Jul 2021 11:51:35 +0200 (CEST)
Date:   Thu, 29 Jul 2021 11:51:35 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Message-ID: <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be>
In-Reply-To: <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
References: <20210724172108.26524-1-justin.iurman@uliege.be> <20210724172108.26524-2-justin.iurman@uliege.be> <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: Add, show, link, remove IOAM namespaces and schemas
Thread-Index: nxNGtm/H3q59yPPChfOO7wXS/4hiAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

>> +static void print_schema(struct rtattr *attrs[])
>> +{
>> +	__u8 data[IOAM6_MAX_SCHEMA_DATA_LEN + 1];
>> +	int len;
>> +
>> +	print_uint(PRINT_ANY, "schema", "schema %u",
>> +		   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
>> +
>> +	if (attrs[IOAM6_ATTR_NS_ID])
>> +		print_uint(PRINT_ANY, "namespace", " [namespace %u]",
>> +			   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
>> +
>> +	len = RTA_PAYLOAD(attrs[IOAM6_ATTR_SC_DATA]);
>> +	memcpy(data, RTA_DATA(attrs[IOAM6_ATTR_SC_DATA]), len);
>> +	data[len] = '\0';
>> +
>> +	print_string(PRINT_ANY, "data", ", data \"%s\"", (const char *)data);
> 
> The attribute descriptions shows this as binary data, not a string.

Indeed. Maybe should I print it as hex... What do you think is more appropriate for this?


>> +static int ioam6_do_cmd(void)
>> +{
>> +	IOAM6_REQUEST(req, 1036, opts.cmd, NLM_F_REQUEST);
>> +	int dump = 0;
>> +
>> +	if (genl_family < 0) {
>> +		if (rtnl_open_byproto(&grth, 0, NETLINK_GENERIC) < 0) {
>> +			fprintf(stderr, "Cannot open generic netlink socket\n");
>> +			exit(1);
>> +		}
>> +		genl_family = genl_resolve_family(&grth, IOAM6_GENL_NAME);
> 
> The above 2 calls can be done with genl_init_handle.

Didn't know that one, thx for the pointer.


>> +int do_ioam6(int argc, char **argv)
>> +{
>> +	bool maybe_wide = false;
>> +
>> +	if (argc < 1 || matches(*argv, "help") == 0)
>> +		usage();
>> +
>> +	memset(&opts, 0, sizeof(opts));
>> +
>> +	if (matches(*argv, "namespace") == 0) {
> 
> matches has been shown to be quite frail. Convenient for shorthand
> typing commands, but frail in the big picture. We should stop using it -
> especially for new commands.

Sure. What do you suggest as an alternative?
