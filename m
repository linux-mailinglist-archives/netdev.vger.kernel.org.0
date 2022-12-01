Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6327B63F4AA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiLAQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLAQAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:00:30 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF5B0A3A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:00:27 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q12so2246639pfn.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EICqlOY2wSVfJTEjuLD6mKeHy9df5RQvMNrOMhI1/ws=;
        b=vppqG4m+H61rIo+uYj30E7gmBrNOPHH6TrVKIhlkBbRhQJooIBsya6CdCRLqGuoXf2
         6SbjF8KHY/4qDBUGlyWIsQuTgeEqKF9ye+kmfoN1v4YChBrK2uvRjHNhdFNxbBbt6enz
         4h5kwwDdLDv6CJvyiEqGaVMkD+K7Bo8A9JXiO+S6SrBoYXcSauW3/Hh+8RuP09xd4JpO
         Umio5FQ36F0zwtMQu+cKZ/qTL+esvscTz7QT4tlLxCoP7JxxUQ5JaLU6e3p6jyK2MtoN
         9f5Wv45y5g6thDu8lZC88uzYZpgOmstq8Fm9OlHvd+5PoUNdoBJNUz5vWpFE8sP/KPPZ
         Ig/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EICqlOY2wSVfJTEjuLD6mKeHy9df5RQvMNrOMhI1/ws=;
        b=1fAOHMigT+a+Ntp4hIFKb9U2CkgWYLkg6HjzzNfz/ogWiRbpDyU48n3BKbS9ngnr3Q
         /K5V7pyXClmq8lJy4OmkcAAT7Jhkp3T3tzc9aEGo6ZdnTbLH8yrqlOmVwAP7JsIQB00+
         s77XNbxJfMFrkFnOXG8bVYpxxhbONj1uI5wEMpsyTh2pqCNdMRFJVu+mNqKOT676NUPf
         e0RPWTzSa5aR3GvnGjzw8iSv/POp0f+xXuAHWJgEuk+CH5Rnkrl+j2lQnn88JdCyEj2W
         gbk9cfNTaedckdXbKFpjIGMKPtDuWWpLVobe/p2f6mD7Zcxkj6kB7J/zSkT+mxkUqO75
         l/aA==
X-Gm-Message-State: ANoB5pkKFPRcN6s11kUWM8QNdfPYombdE8O4TWYu8cwi7KmPGFpfzTNi
        x6qZ52I+CAx+WZ+FVwEempD/ZQ==
X-Google-Smtp-Source: AA0mqf6FunmEJ2eHy14vvV4D11PrAcyUwtFZe9cnMmpuEi6daNXDQ0rDwTiervs+NeDDTnQlbQ7LRQ==
X-Received: by 2002:a65:5c4b:0:b0:477:2aac:56bb with SMTP id v11-20020a655c4b000000b004772aac56bbmr57005019pgr.570.1669910426841;
        Thu, 01 Dec 2022 08:00:26 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 137-20020a62198f000000b0056b9ec7e2desm3381478pfz.125.2022.12.01.08.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:00:26 -0800 (PST)
Date:   Thu, 1 Dec 2022 08:00:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Gilad Naaman <gnaaman@drivenets.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lahav Daniel Schlesinger <lschlesinger@drivenets.com>
Subject: Re: [PATCH iproute2] libnetlink: Fix memory leak in
 __rtnl_talk_iov()
Message-ID: <20221201080024.719fe24e@hermes.local>
In-Reply-To: <D239DD38-BC1F-42BE-B854-7DED97F11D91@drivenets.com>
References: <D239DD38-BC1F-42BE-B854-7DED97F11D91@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Nov 2022 16:15:41 +0000
Gilad Naaman <gnaaman@drivenets.com> wrote:

> If `__rtnl_talk_iov()` fails then callers are not expected to free `answer`.
> 
> Currently if `NLMSG_ERROR` was received with an error then the netlink
> buffer was stored in `answer`, while still returning an error
> 
> This leak can be observed by running this snippet over time.
> This triggers an `NLMSG_ERROR` because for each neighbour update, `ip`
> will try to query for the name of interface 9999 in the wrong netns.
> (which in itself is a separate bug)
> 
> 	set -e
> 
> 	ip netns del test-a || true
> 	ip netns add test-a
> 	ip netns del test-b || true
> 	ip netns add test-b
> 
> 	ip -n test-a netns set test-b auto
> 	ip -n test-a link add veth_a index 9999 type veth peer name veth_b netns test-b
> 	ip -n test-b link set veth_b up
> 
> 	ip -n test-a monitor link address prefix neigh nsid label all-nsid > /dev/null &
> 	monitor_pid=$!
> 	clean() {
> 		kill $monitor_pid
> 		ip netns del test-a
> 		ip netns del test-b
> 	}
> 	trap clean EXIT
> 
> 	while true; do
> 		ip -n test-b neigh add dev veth_b 1.2.3.4 lladdr AA:AA:AA:AA:AA:AA
> 		ip -n test-b neigh del dev veth_b 1.2.3.4
> 	done
> 
> Fixes: 55870df ("Improve batch and dump times by caching link lookups")
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
> ---
> lib/libnetlink.c | 17 +++++++++++------
> 1 file changed, 11 insertions(+), 6 deletions(-)

The patch got mangled by MS Exchange.  Please resubmit with proper formatting.

$ checkpatch.pl /tmp/leak.mbox 
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#148: 
If `__rtnl_talk_iov()` fails then callers are not expected to free `answer`=

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: 55870dfe7f8b ("Improve batch and dump times by caching link lookups")'
#186: 
Fixes: 55870df ("Improve batch and dump times by caching link lookups")

ERROR: patch seems to be corrupt (line wrapped?)
#198: FILE: lib/libnetlink.c:1091:
						rtnl_talk_error(h, err, errfn);

WARNING: suspect code indent for conditional statements (32, 32)
#204: FILE: lib/libnetlink.c:1093:
+				if (i < iovlen) {
					free(buf);

WARNING: space prohibited between function name and open parenthesis '('
#218: FILE: lib/libnetlink.c:1102:
+					*answer =3D (struct nlmsghdr *)buf;

ERROR: spaces required around that '=' (ctx:WxV)
#218: FILE: lib/libnetlink.c:1102:
+					*answer =3D (struct nlmsghdr *)buf;
 					        ^

total: 2 errors, 4 warnings, 29 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

/tmp/leak.mbox has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.




