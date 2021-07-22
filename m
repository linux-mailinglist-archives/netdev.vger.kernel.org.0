Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23443D2BC5
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhGVRcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:32:25 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:41367 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhGVRcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:32:24 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 70A49200EEA7;
        Thu, 22 Jul 2021 20:12:57 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 70A49200EEA7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626977577;
        bh=6Zr2/BlHxrUVXAqntzmEnA/uURmuPR7k9LbIE6QBTDM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=oji71czjA7dwFMsSKg7QSjNDyENStJZ1QEjBNErlkN6bxS6bcnT0B84I6w9YaOaaF
         mSTSXILNtAbIWlaRScZO+94+evOiUQPAHqRhR0CSa736rj31fdkXERqHgR0kMirzok
         oX8MIFtACB+2veYJIxxQSorig9SWI6CksAqX+MpkLOHg6UaWQVXWUNE0vq2cESJaJX
         hpzxuTWjnlmP2lan5slxERcq0cffKhO56mscuT85i0/oBoz+PnNgT7waovMP6GHw2w
         a7sAi/+X8cjaZidJl26mrUFsZNzxFxmnEWOIZDBq1ItKQKDNWdcHqO/auWZYzWV7td
         y57zxeAqfpWfw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 6413E602253FE;
        Thu, 22 Jul 2021 20:12:57 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JEpuVOLquhx4; Thu, 22 Jul 2021 20:12:57 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 481DC6008D842;
        Thu, 22 Jul 2021 20:12:57 +0200 (CEST)
Date:   Thu, 22 Jul 2021 20:12:57 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
Message-ID: <423321698.25016549.1626977577261.JavaMail.zimbra@uliege.be>
In-Reply-To: <631216ff-c8ec-b602-e1ce-95808dd92b01@gmail.com>
References: <20210720194301.23243-1-justin.iurman@uliege.be> <20210720194301.23243-7-justin.iurman@uliege.be> <631216ff-c8ec-b602-e1ce-95808dd92b01@gmail.com>
Subject: Re: [PATCH net-next v5 6/6] selftests: net: Test for the IOAM
 insertion with IPv6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: selftests: net: Test for the IOAM insertion with IPv6
Thread-Index: Hq5pHxo7wTFPMHEQkY23crhEsUqH3w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +run()
>> +{
>> +  echo -n "IOAM test... "
>> +
>> +  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
>> +  if [ $? != 0 ]; then
>> +    echo "FAILED"
>> +    cleanup &>/dev/null
>> +    exit 0
>> +  fi
>> +
>> +  ip netns exec ioam-node-gamma ./ioam6_parser veth0 2 ${IOAM_NAMESPACE}
>> ${IOAM_TRACE_TYPE} 64 ${ALPHA[0]} ${ALPHA[1]} ${ALPHA[2]} ${ALPHA[3]}
>> ${ALPHA[4]} ${ALPHA[5]} ${ALPHA[6]} ${ALPHA[7]} ${ALPHA[8]} "${ALPHA[9]}" 63
>> ${BETA[0]} ${BETA[1]} ${BETA[2]} ${BETA[3]} ${BETA[4]} ${BETA[5]} ${BETA[6]}
>> ${BETA[7]} ${BETA[8]} &
>> +
>> +  local spid=$!
>> +  sleep 0.1
>> +
>> +  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
>> +
>> +  wait $spid
>> +  [ $? = 0 ] && echo "PASSED" || echo "FAILED"
>> +}
>> +
>> +cleanup &>/dev/null
>> +setup
>> +run
>> +cleanup &>/dev/null
> 
> Can you add negative tests as well? i.e, things work like they should
> when enabled and configured properly, fail when the test should not and
> include any invalid combinations of parameters.

Hmmm... I think I got your point but not sure on details you have in mind. Maybe should we take a table during the netdev conf and discuss it live.
