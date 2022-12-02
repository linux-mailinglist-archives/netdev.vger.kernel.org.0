Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828A163FF8B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiLBEqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLBEp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:45:59 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CB1D678B
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 20:45:57 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id z131so2452277iof.3
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 20:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3XlLmtblvaKEcOrFFXLF/OMJhd57ijtz6CGLb6ga1g=;
        b=MmoQKRNQCqPBIQnG4m8n3l5Fu1uXD2XafoCWmXnpookD459vPcRJ4Hk0+LgxQB1vbW
         LPNm89HoawNwYpLzEY8RseO8GmV7fz90qm0qrsckcVRyZsKfUi+6tVeolSZNL4+LfmO5
         jeWs8IF5zjbWDPecqUF3/AHxByiP6yWvyFo4+p6KXIpCAmd7Ny41u16NmA+k2Vg0exH6
         uolSvVsxIRHuqwq2uXUfLU+oqJgfUQ9zn75/ySXYDBR2VV5GgmlZ4wIU+WtSh77AYXGm
         WHYk4HMt+fuy3Mdwy6J+5mnl4R8pPA+Mjv3szxV814mxGPFrb5PEgb8p8vEKzeYYuGSS
         vEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U3XlLmtblvaKEcOrFFXLF/OMJhd57ijtz6CGLb6ga1g=;
        b=sdGdQeWwzuwOl4UWlVc2hATrcZJrogj2J6V3LmjInIeq+n1o27qfphu2oGMk9vYrRg
         /PIbrfvWZMCQUtwJPgIbDFkaz/u3dkJG3Qet9fKU7O/CO2ci71e4X2eSxYH/E7zDk63R
         lKp3qJpUGeKyEOcQx5j8/5mJs9eo6qfQHVvrLwimQdRjbQROEwhYO2s1PxmmyweHXzpl
         iaZDFLdJ3T8fDwSCht+dAzuSCuyaP+G3BmozfzEJFdp6MuQwjiCr9LfYF0xAERBaf583
         fxUDbZ3O9LI6fS4HYiy1/t6zy8uxoTCNHzsbwfjA9gz5yniG5c6aVpgbiteYA0m7xsak
         hYxg==
X-Gm-Message-State: ANoB5pmtPX/XiDyjfRe6HRmf6ikufxR5AtHiMEPunETtvzQsgsvfZXj4
        IfE50bdaQC+QKIdq6oLbXAQs5Lyq1/0=
X-Google-Smtp-Source: AA0mqf6zXIt9UaCGoIOGQtlLEHaSBcCKSTljysRRueCY6tKoa4WVsTXPcbQGf+vFeZl24FDidF3/WA==
X-Received: by 2002:a02:b38c:0:b0:389:b9a5:f14a with SMTP id p12-20020a02b38c000000b00389b9a5f14amr15934356jan.98.1669956357079;
        Thu, 01 Dec 2022 20:45:57 -0800 (PST)
Received: from ?IPV6:2607:fea8:1b9f:f88c::349? ([2607:fea8:1b9f:f88c::349])
        by smtp.gmail.com with ESMTPSA id x19-20020a026f13000000b003640f27d82esm2403375jab.21.2022.12.01.20.45.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 20:45:56 -0800 (PST)
Message-ID: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
Date:   Thu, 1 Dec 2022 23:45:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Subject: Multicast packet reordering
To:     netdev@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'm investigating random multicast packet reordering between 2 containers
even under moderate traffic (16 video multicast, ~80mbps total) on Alma 8.

To simplify the testing, I've reproduced the issue using iperf2, then reproduced the issue on lo.
I can reproduce multicast packet reordering on lo on Alma 8, Alma 9, and Fedora 37, but not on CentOS 7.
As Fedora 37 is using 6.0.7-301.fc37.x86_64 I'm reporting here.

Using RPS fixes the issue, but to make it short:
- Is it expect to have multicast packet reordering when just tuning buffer sizes ?
- Does it make sense to use RPS to fix this issue / anything else / better ?
- In the case of 2 containers talking using veth + bridge, is it better to keep 1 queue
and set rps_cpus to all cpus, or some more complex tuning like 1 queue per cpu + rps on 1 cpu only ?

The details:
On a Dell R7515 / AMD EPYC 7702P 64-Core Processor (128 threads) / 1 NUMA node

For each OS I'm doing 3 tests
1) initial tuning
tuned-adm profile network-throughput
2) increase buffers
sysctl -f - <<'EOF'
net.core.netdev_max_backlog=250000
net.core.rmem_default=33554432
net.core.rmem_max=33554432
net.core.wmem_default=4194304
net.core.wmem_max=4194304
EOF
3) Enable RPS
echo ffffffff,ffffffff,ffffffff,ffffffff > /sys/class/net/lo/queues/rx-0/rps_cpus

I start the servers and the client
for i in {1..10}; do
   iperf -s -u -B 239.255.255.$i%lo -i 1 &
done
iperf -c 239.255.255.1 -B 127.0.0.1 -u -i 1 -b 2G -l 1316 -P 10 --incr-dstip -t0

On Fedora 37, Alma 8&9:
test 1: I get drops and reordering
test 2: no drops but reordering
test 3: clean

On CentOS 7 I don't reach 2G, but I don't get reordering, I get drops at step 1,
all clean at step 2, and drops again when enabling RPS.

Best
Etienne

