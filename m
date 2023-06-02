Return-Path: <netdev+bounces-7280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F27B71F852
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47EE71C211A7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE6410E3;
	Fri,  2 Jun 2023 02:13:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8D15A3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:13:27 +0000 (UTC)
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A824F138;
	Thu,  1 Jun 2023 19:13:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
	by APP-01 (Coremail) with SMTP id qwCowACHj_szUHlkEgfGCQ--.60181S2;
	Fri, 02 Jun 2023 10:13:08 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	davthompson@nvidia.com,
	asmaa@nvidia.com,
	mkl@pengutronix.de,
	limings@nvidia.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Date: Fri,  2 Jun 2023 10:13:05 +0800
Message-Id: <20230602021305.29926-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHj_szUHlkEgfGCQ--.60181S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF4DJw1DXrykur18Cr18AFb_yoW8Cr1Up3
	ykKwn5ArWkJa4rKw4xu3W3ua4rJ3WUCry3Wrn09a18Z347Jrn5GryS9rWavF1UCr1kZrZ8
	JFnFqryUtw47Aa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUO_MaUUUUU
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 1 Jun 2023 23:54:02 +0800 Jakub Kicinski wrote:
> On Thu,  1 Jun 2023 14:58:08 +0800 Jiasheng Jiang wrote:
>> According to the documentation of submitting patches
>> (Link: https://docs.kernel.org/process/submitting-patches.html),
>> I used "scripts/get_maintainer.pl" to gain the appropriate recipients
>> for my patch.
>> However, the "limings@nvidia.com" is not contained in the following list.
> 
> And I told you already to run the script on the _patch_ not on the file
> path.
> 
> $ ./scripts/get_maintainer.pl 0001-mlxbf_gige-Add-missing-check-for-platform_get_irq.patch
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,blamed_fixes:1/1=100%)
> Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS,commit_signer:5/6=83%,authored:1/6=17%,removed_lines:1/20=5%)
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
> Asmaa Mnebhi <asmaa@nvidia.com> (commit_signer:4/6=67%,blamed_fixes:1/1=100%)
> David Thompson <davthompson@nvidia.com> (commit_signer:4/6=67%,authored:4/6=67%,added_lines:94/99=95%,removed_lines:19/20=95%,blamed_fixes:1/1=100%)
> Marc Kleine-Budde <mkl@pengutronix.de> (commit_signer:1/6=17%)
> Jiasheng Jiang <jiasheng@iscas.ac.cn> (commit_signer:1/6=17%,authored:1/6=17%)
> vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
> Liming Sun <limings@nvidia.com> (blamed_fixes:1/1=100%)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)

I have got it. I will run the script on the patch.

Thanks,
Jiang


