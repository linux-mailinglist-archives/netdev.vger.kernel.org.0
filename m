Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5236177F27
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 13:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfG1LPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 07:15:41 -0400
Received: from smtprelay07.ispgateway.de ([134.119.228.97]:2653 "EHLO
        smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfG1LPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 07:15:41 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jul 2019 07:15:40 EDT
Received: from [185.124.72.17] (helo=[192.168.0.168])
        by smtprelay07.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ich@michaelziegler.name>)
        id 1hrh3r-0000Vp-UU
        for netdev@vger.kernel.org; Sun, 28 Jul 2019 13:09:55 +0200
To:     netdev@vger.kernel.org
From:   Michael Ziegler <ich@michaelziegler.name>
Subject: ip route JSON format is unparseable for "unreachable" routes
Message-ID: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
Date:   Sun, 28 Jul 2019 13:09:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Df-Sender: aWNoQG1pY2hhZWx6aWVnbGVyLm5hbWU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I created a couple "unreachable" routes on one of my systems, like such:

> ip route add unreachable 10.0.0.0/8     metric 255
> ip route add unreachable 192.168.0.0/16 metric 255

Unfortunately this results in unparseable JSON output from "ip":

> # ip -j route show  | jq .
> parse error: Objects must consist of key:value pairs at line 1, column 84

The offending JSON objects are these:

> {"unreachable","dst":"10.0.0.0/8","metric":255,"flags":[]}
> {"unreachable","dst":"192.168.0.0/16","metric":255,"flags":[]}
"unreachable" cannot appear on its own here, it needs to be some kind of
field.

The manpage says to report here, thus I do :) I've searched the
archives, but I wasn't able to find any existing bug reports about this.
I'm running version

> ip utility, iproute2-ss190107

on Debian Buster.

Regards,
Michael.
