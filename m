Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5B1B62E1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 20:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgDWSDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 14:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729901AbgDWSDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 14:03:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E5620784;
        Thu, 23 Apr 2020 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587664989;
        bh=ziAI6VG2XH9RfrerF4KDmZg6xbgoPusayEtFKaaD17U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pKyf3BtlDnUhP/IZ8zTG0TdMD2G+9JKmpNGmRf725XGLyXkbsYTvRvajY2uk9G5to
         CVraKLIdntsqsKpdfc0NPvS50W+dTZUqhzIBidlT9SDbsYfvI6z/V2wm6475WcDf72
         ZJ5RMHcgWqCn3Emx8fCYfWCFH960is+l3VzMGKBg=
Date:   Thu, 23 Apr 2020 11:03:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200423110307.6e35fc7d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200423082351.5cd10f4d@hermes.lan>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
        <20200214081324.48dc2090@hermes.lan>
        <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
        <20200423082351.5cd10f4d@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 08:23:51 -0700 Stephen Hemminger wrote:
>  3. If non json uses hex, then json should use hex
>     json is type less so { "ver":2 } and { "ver":"0x2" } are the same

I may be missing something or misunderstanding you, but in my humble
experience that's emphatically not true:

$ echo '{ "a" : 2 }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
3
$ echo '{ "a" : "2" }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
Traceback (most recent call last):
  File "<string>", line 1, in <module>
TypeError: can only concatenate str (not "int") to str
