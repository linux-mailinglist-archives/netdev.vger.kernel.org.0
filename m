Return-Path: <netdev+bounces-4963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B931E70F60C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659381C20C8D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E617FFD;
	Wed, 24 May 2023 12:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373D17ADA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:17:17 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586429E;
	Wed, 24 May 2023 05:17:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id B814360171;
	Wed, 24 May 2023 14:17:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684930632; bh=7oaHgsYtGJMz7ohGu+nRJErGUb5J0i5cHkLkmjiGsqE=;
	h=Date:From:Subject:To:Cc:From;
	b=gDdy0PmrUhfA8awUg01ac5maTXvy/enMvSPmzLB6HNBXtfjkDT6dJP0mBeq4F+Ve8
	 1KRKVaUk5BcAz7dfo8VPuD9C0aNb24/AQu6sNzLEQxh7dkYwiesJeUvRTuurhwxbnF
	 Z49M0ygHp+wciR92alsYw9q+/WLXSnhvzZcFTmojl8iLoCRt8N1gIW6ppg1Dle/6xk
	 W4rszBHGzYquAgXsrZ/W5nKtS3ho4jVrmWOB1wdVP2oHm0/ba6r8LY5vcujpUBRPZh
	 QBU1eEvAXGE84OZqWm0evlTCE5LWdHTqaVVPURlS+N+wU9xgN3vjrHD0OUSzIT0ExX
	 VGybdFkWpegRw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1gKch49mTtPy; Wed, 24 May 2023 14:17:10 +0200 (CEST)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
	by domac.alu.hr (Postfix) with ESMTPSA id D1A0F6016E;
	Wed, 24 May 2023 14:17:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684930630; bh=7oaHgsYtGJMz7ohGu+nRJErGUb5J0i5cHkLkmjiGsqE=;
	h=Date:From:Subject:To:Cc:From;
	b=kAARxCy4DpHwrwqLgbkQcCFSYZ8BUmT2gtK70wCHT8fOKyfvApClcRkl+tlDiOsgl
	 revW1jwANOS/d32z3UUr+ZHyYneFumPFWTNzVDcDvYM30h/ABAlzdgczUESxdzqDFc
	 3qGhvZoNzjK+FkcBPA3WEMjyLgolJ1vHEeOotfP7OUWNHQWmKcZSYkVVgTtQ6vR4gZ
	 89CQfrMJ7mAJ76Qd9dkCLTSZD35AamRNjmqc3meQkHWnnbGDxam/aWiiKCVJRNezc9
	 yo6PHklYMVm+jh0CrYvAcojQNhkQhd+xKOIkFtxLV9hgDc82/jBWPKTZzo+502UPl2
	 5QfgyMlBZRrNQ==
Message-ID: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
Date: Wed, 24 May 2023 14:17:09 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, hr
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind - ns-B
 IPv6 LLA" test
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

The very recent 6.4-rc3 kernel build with AlmaLinux 8.7 on LENOVO 10TX000VCR
desktop box fails one test:

[root@host net]# ./fcnal-test.sh
[...]
TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [FAIL]
TEST: ping in - ns-A IPv6                                                     [ OK ]
[...]
Tests passed: 887
Tests failed:   1
[root@host net]#

Please find the config, + dmesg and lshw output here:

https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-fcnal-test/config-6.4-rc3
https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-fcnal-test/dmesg.log
https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-fcnal-test/lshw.txt

I believe that I have all required configs merged for the selftest/net tests.

Maybe we have a regression?

My knowledge of fcnal-test.sh isn't sufficient to build a smaller reproducer.

Guillaume said in January he could help with the net/fcnal-test.sh, but I was doing
the other things in the meantime. Tempus fugit :-/

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia

"What’s this thing suddenly coming towards me very fast? Very very fast.
... I wonder if it will be friends with me?"

