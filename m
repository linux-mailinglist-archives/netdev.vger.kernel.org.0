Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1276D509F48
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383032AbiDUMJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382993AbiDUMJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:09:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 05:07:00 PDT
Received: from corp-front10-corp.i.nease.net (corp-front10-corp.i.nease.net [42.186.62.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC2DB7DE;
        Thu, 21 Apr 2022 05:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=tQeayTvVTkuMZ/0xrbpj2RzBxttwLw7oyQ
        PAgMMBKbg=; b=ivTnuNFDMUHQ3QYHZt9WoWpLqOwO6EmtPkaRT8qDRT4hZptmzr
        1K0NOKPUX7Y3CUG/rsAko2UisL4+8QzuKtcTwc2qrv1IsO1zWgbXUiagaDu7YTTb
        o3Xhuj5nNb3EPaiIBfnrqKVGVJ4NP2jeyRiN8XGSRNm2bG5xb8dCPtLT4=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front10-corp.i.nease.net (Coremail) with SMTP id aIG_CgCnHRFFR2FisoQCAA--.5262S2;
        Thu, 21 Apr 2022 20:00:05 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        tonylu@linux.alibaba.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: sync err code when tcp connection was refused
Date:   Thu, 21 Apr 2022 19:58:05 +0800
Message-Id: <20220421115805.1642771-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220421094027.683992-1-liuyacan@corp.netease.com>
References: <20220421094027.683992-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aIG_CgCnHRFFR2FisoQCAA--.5262S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUrF7k042IE4IxYO2xFxVAqjxCEw4Av424l
        14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwV
        WUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE
        14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aV
        AFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9v
        y-n0Xa0_Xr1Utr1kJwI_Jr4ln4vEF7Iv6F18KVAqrcv_GVWUtr1rJF1ln4vE4IxY62xKV4
        CY8xCE548m6r4UJryUGwAa7VCY0VAaVVAqrcv_Jw1UWr13M2AIxVAIcxkEcVAq07x20xvE
        ncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14
        v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY
        c2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4
        kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAKI48JMxAIw28IcxkI7VAKI48JMxCj
        nVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbVAxMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRiE_M7UUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQADCVt76hKvDAABs1
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yacan Liu <liuyacan@corp.netease.com>

Forgot to cc ubraun@linux.ibm.com

