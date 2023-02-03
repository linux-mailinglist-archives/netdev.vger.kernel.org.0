Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF1B689979
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjBCNK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjBCNKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:10:54 -0500
X-Greylist: delayed 604 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 05:10:49 PST
Received: from pv50p00im-tydg10011801.me.com (pv50p00im-tydg10011801.me.com [17.58.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7314C13528
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1675429245;
        bh=rYnqaTBsw/U/TQO7aVROGFUL9Jr4ON8ZCCMb+UhidV8=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=xisTmYYsx84Q1XeARNh8DUG0jtIYmfcKX88UdXoG6Y3k3cpr9th6fAtPzWIUxNRVt
         9odNHhtjJC2DsnNzcffvx0hGQ7NG3hnx+TZfTEcaDiVgbV/WbCPp7kABvdhh1NQQye
         lpmeZOmG0NXUowNDb99vq2YX1nYvMd0RnLaxp9qPgp0cWqiDUS+eejHRd/Ci7nIoFF
         crWR3GtEqKt0Wgq+yffU9lIvU+fZMKcQ18awXSS++AuR+kEhCpIT5OuWhaB9P7GLI8
         K65nnveR1GBZjn+QHC9rlnwamEYFKB8VJI7bHPzU7Rvolek1ac8rCDzHmpAb4Wegpe
         igZsP2S3aMK9Q==
Received: from [192.168.178.34] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10011801.me.com (Postfix) with ESMTPSA id 3A63E8008D1;
        Fri,  3 Feb 2023 13:00:42 +0000 (UTC)
Message-ID: <00f95478-c9cc-1f4b-820e-d427a9113418@icloud.com>
Date:   Fri, 3 Feb 2023 14:00:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Lucy Mielke <mielkesteven@icloud.com>
Subject: [PATCH] atm: eni: replace DPRINTK macro with pr_debug()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: yqf8M_RDEnYnJ_m6kmG6BQw9be2Z4ViY
X-Proofpoint-ORIG-GUID: yqf8M_RDEnYnJ_m6kmG6BQw9be2Z4ViY
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 clxscore=1011 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302030120
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro DPRINTK is in use in lots of different source files, varying in
their implementation. One of those files is drivers/atm/eni.c.

Replacing them with pr_debug() and their counterparts makes it more
consistent and easier to read.

If this is still desireable and relevant, I will continue with the rest
of the source files.

Signed-off-by: Lucy Mielke <mielkesteven@icloud.com>
---
 drivers/atm/eni.c | 132 ++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 70 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index a31ffe16e626..17215b2803aa 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -55,14 +55,6 @@
  *   2^n block (never happens in real life, though)
  */
 
-
-#if 0
-#define DPRINTK(format,args...) printk(KERN_DEBUG format,##args)
-#else
-#define DPRINTK(format,args...)
-#endif
-
-
 #ifndef CONFIG_ATM_ENI_TUNE_BURST
 #define CONFIG_ATM_ENI_BURST_TX_8W
 #define CONFIG_ATM_ENI_BURST_RX_4W
@@ -199,7 +191,7 @@ static void eni_put_free(struct eni_dev *eni_dev, void __iomem *start,
     struct eni_free *list;
     int len,order;
 
-    DPRINTK("init 0x%lx+%ld(0x%lx)\n",start,size,size);
+    pr_debug("init 0x%lx+%ld(0x%lx)\n",start,size,size);
     start += eni_dev->base_diff;
     list = eni_dev->free_list;
     len = eni_dev->free_len;
@@ -238,7 +230,7 @@ static void __iomem *eni_alloc_mem(struct eni_dev *eni_dev, unsigned long *size)
     if (*size > MID_MAX_BUF_SIZE) return NULL;
     for (order = 0; (1 << order) < *size; order++)
         ;
-    DPRINTK("trying: %ld->%d\n",*size,order);
+    pr_debug("trying: %ld->%d\n",*size,order);
     best_order = 65; /* we don't have more than 2^64 of anything ... */
     index = 0; /* silence GCC */
     for (i = 0; i < len; i++)
@@ -257,7 +249,7 @@ static void __iomem *eni_alloc_mem(struct eni_dev *eni_dev, unsigned long *size)
     eni_dev->free_len = len;
     *size = 1 << order;
     eni_put_free(eni_dev,start+*size,(1 << best_order)-*size);
-    DPRINTK("%ld bytes (order %d) at 0x%lx\n",*size,order,start);
+    pr_debug("%ld bytes (order %d) at 0x%lx\n",*size,order,start);
     memset_io(start,0,*size);       /* never leak data */
     /*dump_mem(eni_dev);*/
     return start;
@@ -274,11 +266,11 @@ static void eni_free_mem(struct eni_dev *eni_dev, void __iomem *start,
     list = eni_dev->free_list;
     len = eni_dev->free_len;
     for (order = -1; size; order++) size >>= 1;
-    DPRINTK("eni_free_mem: %p+0x%lx (order %d)\n",start,size,order);
+    pr_debug("eni_free_mem: %p+0x%lx (order %d)\n",start,size,order);
     for (i = 0; i < len; i++)
         if (((unsigned long) list[i].start) == ((unsigned long)start^(1 << order)) &&
             list[i].order == order) {
-            DPRINTK("match[%d]: 0x%lx/0x%lx(0x%x), %d/%d\n",i,
+            pr_debug("match[%d]: 0x%lx/0x%lx(0x%x), %d/%d\n",i,
                 list[i].start,start,1 << order,list[i].order,order);
             list[i] = list[--len];
             start = (void __iomem *) ((unsigned long) start & ~(unsigned long) (1 << order));
@@ -376,7 +368,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
         unsigned long words;
 
         if (!size) {
-            DPRINTK("strange things happen ...\n");
+            pr_debug("strange things happen ...\n");
             EVENT("strange things happen ... (skip=%ld,eff=%ld)\n",
                 size,eff);
         }
@@ -510,7 +502,7 @@ static int rx_aal0(struct atm_vcc *vcc)
     unsigned long length;
     struct sk_buff *skb;
 
-    DPRINTK(">rx_aal0\n");
+    pr_debug(">rx_aal0\n");
     eni_vcc = ENI_VCC(vcc);
     descr = readl(eni_vcc->recv+eni_vcc->descr*4);
     if ((descr & MID_RED_IDEN) != (MID_RED_RX_ID << MID_RED_SHIFT)) {
@@ -518,7 +510,7 @@ static int rx_aal0(struct atm_vcc *vcc)
         return 1;
     }
     if (descr & MID_RED_T) {
-        DPRINTK(DEV_LABEL "(itf %d): trashing empty cell\n",
+        pr_debug(DEV_LABEL "(itf %d): trashing empty cell\n",
             vcc->dev->number);
         length = 0;
         atomic_inc(&vcc->stats->rx_err);
@@ -533,7 +525,7 @@ static int rx_aal0(struct atm_vcc *vcc)
     }
     skb_put(skb,length);
     skb->tstamp = eni_vcc->timestamp;
-    DPRINTK("got len %ld\n",length);
+    pr_debug("got len %ld\n",length);
     if (do_rx_dma(vcc,skb,1,length >> 2,length >> 2)) return 1;
     eni_vcc->rxing++;
     return 0;
@@ -548,7 +540,7 @@ static int rx_aal5(struct atm_vcc *vcc)
     struct sk_buff *skb;
 
     EVENT("rx_aal5\n",0,0);
-    DPRINTK(">rx_aal5\n");
+    pr_debug(">rx_aal5\n");
     eni_vcc = ENI_VCC(vcc);
     descr = readl(eni_vcc->recv+eni_vcc->descr*4);
     if ((descr & MID_RED_IDEN) != (MID_RED_RX_ID << MID_RED_SHIFT)) {
@@ -558,7 +550,7 @@ static int rx_aal5(struct atm_vcc *vcc)
     if (descr & (MID_RED_T | MID_RED_CRC_ERR)) {
         if (descr & MID_RED_T) {
             EVENT("empty cell (descr=0x%lx)\n",descr,0);
-            DPRINTK(DEV_LABEL "(itf %d): trashing empty cell\n",
+            pr_debug(DEV_LABEL "(itf %d): trashing empty cell\n",
                 vcc->dev->number);
             size = 0;
         }
@@ -580,7 +572,7 @@ static int rx_aal5(struct atm_vcc *vcc)
     }
     else {
         size = (descr & MID_RED_COUNT)*(ATM_CELL_PAYLOAD >> 2);
-        DPRINTK("size=%ld\n",size);
+        pr_debug("size=%ld\n",size);
         length = readl(eni_vcc->recv+(((eni_vcc->descr+size-1) &
             (eni_vcc->words-1)))*4) & 0xffff;
                 /* -trailer(2)+header(1) */
@@ -602,7 +594,7 @@ static int rx_aal5(struct atm_vcc *vcc)
         return 0;
     }
     skb_put(skb,length);
-    DPRINTK("got len %ld\n",length);
+    pr_debug("got len %ld\n",length);
     if (do_rx_dma(vcc,skb,1,size,eff)) return 1;
     eni_vcc->rxing++;
     return 0;
@@ -622,7 +614,7 @@ static inline int rx_vcc(struct atm_vcc *vcc)
         MID_VCI_DESCR_SHIFT)) {
         EVENT("rx_vcc(2: host dsc=0x%lx, nic dsc=0x%lx)\n",
             eni_vcc->descr,tmp);
-        DPRINTK("CB_DESCR %ld REG_DESCR %d\n",ENI_VCC(vcc)->descr,
+        pr_debug("CB_DESCR %ld REG_DESCR %d\n",ENI_VCC(vcc)->descr,
             (((unsigned) readl(vci_dsc+4) & MID_VCI_DESCR) >>
             MID_VCI_DESCR_SHIFT));
         if (ENI_VCC(vcc)->rx(vcc)) return 1;
@@ -639,7 +631,7 @@ static inline int rx_vcc(struct atm_vcc *vcc)
         >> MID_VCI_DESCR_SHIFT)) {
         EVENT("rx_vcc(4: host dsc=0x%lx, nic dsc=0x%lx)\n",
             eni_vcc->descr,tmp);
-        DPRINTK("CB_DESCR %ld REG_DESCR %d\n",ENI_VCC(vcc)->descr,
+        pr_debug("CB_DESCR %ld REG_DESCR %d\n",ENI_VCC(vcc)->descr,
             (((unsigned) readl(vci_dsc+4) & MID_VCI_DESCR) >>
             MID_VCI_DESCR_SHIFT));
         if (ENI_VCC(vcc)->rx(vcc)) return 1;
@@ -679,7 +671,7 @@ static void get_service(struct atm_dev *dev)
     struct atm_vcc *vcc;
     unsigned long vci;
 
-    DPRINTK(">get_service\n");
+    pr_debug(">get_service\n");
     eni_dev = ENI_DEV(dev);
     while (eni_in(MID_SERV_WRITE) != eni_dev->serv_read) {
         vci = readl(eni_dev->service+eni_dev->serv_read*4);
@@ -694,7 +686,7 @@ static void get_service(struct atm_dev *dev)
         EVENT("getting from service\n",0,0);
         if (ENI_VCC(vcc)->next != ENI_VCC_NOS) {
             EVENT("double service\n",0,0);
-            DPRINTK("Grr, servicing VCC %ld twice\n",vci);
+            pr_debug("Grr, servicing VCC %ld twice\n",vci);
             continue;
         }
         ENI_VCC(vcc)->timestamp = ktime_get_real();
@@ -732,7 +724,7 @@ static void dequeue_rx(struct atm_dev *dev)
         skb = skb_dequeue(&eni_dev->rx_queue);
         if (!skb) {
             if (first) {
-                DPRINTK(DEV_LABEL "(itf %d): RX but not "
+                pr_debug(DEV_LABEL "(itf %d): RX but not "
                     "rxing\n",dev->number);
                 EVENT("nothing to dequeue\n",0,0);
             }
@@ -778,7 +770,7 @@ static int open_rx_first(struct atm_vcc *vcc)
     struct eni_vcc *eni_vcc;
     unsigned long size;
 
-    DPRINTK("open_rx_first\n");
+    pr_debug("open_rx_first\n");
     eni_dev = ENI_DEV(vcc->dev);
     eni_vcc = ENI_VCC(vcc);
     eni_vcc->rx = NULL;
@@ -788,7 +780,7 @@ static int open_rx_first(struct atm_vcc *vcc)
         MID_MAX_BUF_SIZE)
         size = MID_MAX_BUF_SIZE;
     eni_vcc->recv = eni_alloc_mem(eni_dev,&size);
-    DPRINTK("rx at 0x%lx\n",eni_vcc->recv);
+    pr_debug("rx at 0x%lx\n",eni_vcc->recv);
     eni_vcc->words = size >> 2;
     if (!eni_vcc->recv) return -ENOBUFS;
     eni_vcc->rx = vcc->qos.aal == ATM_AAL5 ? rx_aal5 : rx_aal0;
@@ -809,13 +801,13 @@ static int open_rx_second(struct atm_vcc *vcc)
     unsigned long size;
     int order;
 
-    DPRINTK("open_rx_second\n");
+    pr_debug("open_rx_second\n");
     eni_dev = ENI_DEV(vcc->dev);
     eni_vcc = ENI_VCC(vcc);
     if (!eni_vcc->rx) return 0;
     /* set up VCI descriptor */
     here = eni_dev->vci+vcc->vci*16;
-    DPRINTK("loc 0x%x\n",(unsigned) (eni_vcc->recv-eni_dev->ram)/4);
+    pr_debug("loc 0x%x\n",(unsigned) (eni_vcc->recv-eni_dev->ram)/4);
     size = eni_vcc->words >> 8;
     for (order = -1; size; order++) size >>= 1;
     writel(0,here+4); /* descr, read = 0 */
@@ -854,7 +846,7 @@ static void close_rx(struct atm_vcc *vcc)
         /* don't accept any new ones */
         eni_dev->rx_map[vcc->vci] = NULL;
         /* wait for RX queue to drain */
-        DPRINTK("eni_close: waiting for RX ...\n");
+        pr_debug("eni_close: waiting for RX ...\n");
         EVENT("RX closing\n",0,0);
         add_wait_queue(&eni_dev->rx_wait,&wait);
         set_current_state(TASK_UNINTERRUPTIBLE);
@@ -930,7 +922,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
 {
     u32 init,words;
 
-    DPRINTK("put_dma: 0x%lx+0x%x\n",(unsigned long) paddr,size);
+    pr_debug("put_dma: 0x%lx+0x%x\n",(unsigned long) paddr,size);
     EVENT("put_dma: 0x%lx+0x%lx\n",(unsigned long) paddr,size);
 #if 0 /* don't complain anymore */
     if (paddr & 3)
@@ -941,7 +933,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
     if (paddr & 3) {
         init = 4-(paddr & 3);
         if (init > size || size < 7) init = size;
-        DPRINTK("put_dma: %lx DMA: %d/%d bytes\n",
+        pr_debug("put_dma: %lx DMA: %d/%d bytes\n",
             (unsigned long) paddr,init,size);
         dma[(*j)++] = MID_DT_BYTE | (init << MID_DMA_COUNT_SHIFT) |
             (chan << MID_DMA_CHAN_SHIFT);
@@ -954,7 +946,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
     if (words && (paddr & 31)) {
         init = 8-((paddr & 31) >> 2);
         if (init > words) init = words;
-        DPRINTK("put_dma: %lx DMA: %d/%d words\n",
+        pr_debug("put_dma: %lx DMA: %d/%d words\n",
             (unsigned long) paddr,init,words);
         dma[(*j)++] = MID_DT_WORD | (init << MID_DMA_COUNT_SHIFT) |
             (chan << MID_DMA_CHAN_SHIFT);
@@ -964,7 +956,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
     }
 #ifdef CONFIG_ATM_ENI_BURST_TX_16W /* may work with some PCI chipsets ... */
     if (words & ~15) {
-        DPRINTK("put_dma: %lx DMA: %d*16/%d words\n",
+        pr_debug("put_dma: %lx DMA: %d*16/%d words\n",
             (unsigned long) paddr,words >> 4,words);
         dma[(*j)++] = MID_DT_16W | ((words >> 4) << MID_DMA_COUNT_SHIFT)
             | (chan << MID_DMA_CHAN_SHIFT);
@@ -975,7 +967,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
 #endif
 #ifdef CONFIG_ATM_ENI_BURST_TX_8W /* recommended */
     if (words & ~7) {
-        DPRINTK("put_dma: %lx DMA: %d*8/%d words\n",
+        pr_debug("put_dma: %lx DMA: %d*8/%d words\n",
             (unsigned long) paddr,words >> 3,words);
         dma[(*j)++] = MID_DT_8W | ((words >> 3) << MID_DMA_COUNT_SHIFT)
             | (chan << MID_DMA_CHAN_SHIFT);
@@ -986,7 +978,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
 #endif
 #ifdef CONFIG_ATM_ENI_BURST_TX_4W /* probably useless if TX_8W or TX_16W */
     if (words & ~3) {
-        DPRINTK("put_dma: %lx DMA: %d*4/%d words\n",
+        pr_debug("put_dma: %lx DMA: %d*4/%d words\n",
             (unsigned long) paddr,words >> 2,words);
         dma[(*j)++] = MID_DT_4W | ((words >> 2) << MID_DMA_COUNT_SHIFT)
             | (chan << MID_DMA_CHAN_SHIFT);
@@ -997,7 +989,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
 #endif
 #ifdef CONFIG_ATM_ENI_BURST_TX_2W /* probably useless if TX_4W, TX_8W, ... */
     if (words & ~1) {
-        DPRINTK("put_dma: %lx DMA: %d*2/%d words\n",
+        pr_debug("put_dma: %lx DMA: %d*2/%d words\n",
             (unsigned long) paddr,words >> 1,words);
         dma[(*j)++] = MID_DT_2W | ((words >> 1) << MID_DMA_COUNT_SHIFT)
             | (chan << MID_DMA_CHAN_SHIFT);
@@ -1007,7 +999,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
     }
 #endif
     if (words) {
-        DPRINTK("put_dma: %lx DMA: %d words\n",(unsigned long) paddr,
+        pr_debug("put_dma: %lx DMA: %d words\n",(unsigned long) paddr,
             words);
         dma[(*j)++] = MID_DT_WORD | (words << MID_DMA_COUNT_SHIFT) |
             (chan << MID_DMA_CHAN_SHIFT);
@@ -1015,7 +1007,7 @@ static inline void put_dma(int chan,u32 *dma,int *j,dma_addr_t paddr,
         paddr += words << 2;
     }
     if (size) {
-        DPRINTK("put_dma: %lx DMA: %d bytes\n",(unsigned long) paddr,
+        pr_debug("put_dma: %lx DMA: %d bytes\n",(unsigned long) paddr,
             size);
         dma[(*j)++] = MID_DT_BYTE | (size << MID_DMA_COUNT_SHIFT) |
             (chan << MID_DMA_CHAN_SHIFT);
@@ -1036,7 +1028,7 @@ static enum enq_res do_tx(struct sk_buff *skb)
     int aal5,dma_size,i,j;
     unsigned char skb_data3;
 
-    DPRINTK(">do_tx\n");
+    pr_debug(">do_tx\n");
     NULLCHECK(skb);
     EVENT("do_tx: skb=0x%lx, %ld bytes\n",(unsigned long) skb,skb->len);
     vcc = ATM_SKB(skb)->vcc;
@@ -1086,7 +1078,7 @@ static enum enq_res do_tx(struct sk_buff *skb)
      */
     if (!NEPMOK(tx->tx_pos,size+TX_GAP,
         eni_in(MID_TX_RDPTR(tx->index)),tx->words)) {
-        DPRINTK(DEV_LABEL "(itf %d): TX full (size %d)\n",
+        pr_debug(DEV_LABEL "(itf %d): TX full (size %d)\n",
             vcc->dev->number,size);
         return enq_next;
     }
@@ -1095,14 +1087,14 @@ static enum enq_res do_tx(struct sk_buff *skb)
     dma_rd = eni_in(MID_DMA_RD_TX);
     dma_size = 3; /* JK for descriptor and final fill, plus final size
              mis-alignment fix */
-DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
+    pr_debug("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
     if (!skb_shinfo(skb)->nr_frags) dma_size += 5;
     else dma_size += 5*(skb_shinfo(skb)->nr_frags+1);
     if (dma_size > TX_DMA_BUF) {
         printk(KERN_CRIT DEV_LABEL "(itf %d): needs %d DMA entries "
             "(got only %d)\n",vcc->dev->number,dma_size,TX_DMA_BUF);
     }
-    DPRINTK("dma_wr is %d, tx_pos is %ld\n",dma_wr,tx->tx_pos);
+    pr_debug("dma_wr is %d, tx_pos is %ld\n",dma_wr,tx->tx_pos);
     if (dma_wr != dma_rd && ((dma_rd+NR_DMA_TX-dma_wr) & (NR_DMA_TX-1)) <
          dma_size) {
         printk(KERN_WARNING DEV_LABEL "(itf %d): TX DMA full\n",
@@ -1125,7 +1117,7 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
         if (aal5) put_dma(tx->index,eni_dev->dma,&j,paddr,skb->len);
         else put_dma(tx->index,eni_dev->dma,&j,paddr+4,skb->len-4);
     else {
-DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
+pr_debug("doing direct send\n"); /* @@@ well, this doesn't work anyway */
         for (i = -1; i < skb_shinfo(skb)->nr_frags; i++)
             if (i == -1)
                 put_dma(tx->index,eni_dev->dma,&j,(unsigned long)
@@ -1146,7 +1138,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
          MID_DMA_COUNT_SHIFT) | (tx->index << MID_DMA_CHAN_SHIFT) |
          MID_DMA_END | MID_DT_JK;
     j++;
-    DPRINTK("DMA at end: %d\n",j);
+    pr_debug("DMA at end: %d\n",j);
     /* store frame */
     writel((MID_SEG_TX_ID << MID_SEG_ID_SHIFT) |
         (aal5 ? MID_SEG_AAL5 : 0) | (tx->prescaler << MID_SEG_PR_SHIFT) |
@@ -1157,7 +1149,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
             (aal5 ? 0 : (skb_data3 & 0xf)) |
         (ATM_SKB(skb)->atm_options & ATM_ATMOPT_CLP ? MID_SEG_CLP : 0),
         tx->send+((tx->tx_pos+1) & (tx->words-1))*4);
-    DPRINTK("size: %d, len:%d\n",size,skb->len);
+    pr_debug("size: %d, len:%d\n",size,skb->len);
     if (aal5)
         writel(skb->len,tx->send+
                     ((tx->tx_pos+size-AAL5_TRAILER) & (tx->words-1))*4);
@@ -1171,7 +1163,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
     ENI_PRV_SIZE(skb) = size;
     ENI_VCC(vcc)->txing += size;
     tx->tx_pos = (tx->tx_pos+size) & (tx->words-1);
-    DPRINTK("dma_wr set to %d, tx_pos is now %ld\n",dma_wr,tx->tx_pos);
+    pr_debug("dma_wr set to %d, tx_pos is now %ld\n",dma_wr,tx->tx_pos);
     eni_out(dma_wr,MID_DMA_WR_TX);
     skb_queue_tail(&eni_dev->tx_queue,skb);
     queued++;
@@ -1186,14 +1178,14 @@ static void poll_tx(struct atm_dev *dev)
     enum enq_res res;
     int i;
 
-    DPRINTK(">poll_tx\n");
+    pr_debug(">poll_tx\n");
     for (i = NR_CHAN-1; i >= 0; i--) {
         tx = &ENI_DEV(dev)->tx[i];
         if (tx->send)
             while ((skb = skb_dequeue(&tx->backlog))) {
                 res = do_tx(skb);
                 if (res == enq_ok) continue;
-                DPRINTK("re-queuing TX PDU\n");
+                pr_debug("re-queuing TX PDU\n");
                 skb_queue_head(&tx->backlog,skb);
                 requeued++;
                 if (res == enq_jam) return;
@@ -1218,7 +1210,7 @@ static void dequeue_tx(struct atm_dev *dev)
         NULLCHECK(vcc);
         tx = ENI_VCC(vcc)->tx;
         NULLCHECK(ENI_VCC(vcc)->tx);
-        DPRINTK("dequeue_tx: next 0x%lx curr 0x%x\n",ENI_PRV_POS(skb),
+        pr_debug("dequeue_tx: next 0x%lx curr 0x%x\n",ENI_PRV_POS(skb),
             (unsigned) eni_in(MID_TX_DESCRSTART(tx->index)));
         if (ENI_VCC(vcc)->txing < tx->words && ENI_PRV_POS(skb) ==
             eni_in(MID_TX_DESCRSTART(tx->index))) {
@@ -1261,7 +1253,7 @@ static int comp_tx(struct eni_dev *eni_dev,int *pcr,int reserved,int *pre,
             for (*pre = 0; *pre < 3; (*pre)++)
                 if (TS_CLOCK/pre_div[*pre]/64 <= *pcr) break;
             div = pre_div[*pre]**pcr;
-            DPRINTK("min div %d\n",div);
+            pr_debug("min div %d\n",div);
             *res = TS_CLOCK/div-1;
         }
         else {
@@ -1272,14 +1264,14 @@ static int comp_tx(struct eni_dev *eni_dev,int *pcr,int reserved,int *pre,
                 if (TS_CLOCK/pre_div[*pre]/64 > -*pcr) break;
             if (*pre < 3) (*pre)++; /* else fail later */
             div = pre_div[*pre]*-*pcr;
-            DPRINTK("max div %d\n",div);
+            pr_debug("max div %d\n",div);
             *res = DIV_ROUND_UP(TS_CLOCK, div)-1;
         }
         if (*res < 0) *res = 0;
         if (*res > MID_SEG_MAX_RATE) *res = MID_SEG_MAX_RATE;
     }
     *pcr = TS_CLOCK/pre_div[*pre]/(*res+1);
-    DPRINTK("out pcr: %d (%d:%d)\n",*pcr,*pre,*res);
+    pr_debug("out pcr: %d (%d:%d)\n",*pcr,*pre,*res);
     return 0;
 }
 
@@ -1325,7 +1317,7 @@ static int reserve_or_set_tx(struct atm_vcc *vcc,struct atm_trafprm *txtp,
             eni_free_mem(eni_dev,mem,size);
             return -EBUSY;
         }
-        DPRINTK("got chan %d\n",tx->index);
+        pr_debug("got chan %d\n",tx->index);
         tx->reserved = tx->shaping = 0;
         tx->send = mem;
         tx->words = size >> 2;
@@ -1367,7 +1359,7 @@ static int reserve_or_set_tx(struct atm_vcc *vcc,struct atm_trafprm *txtp,
         tx->shaping = rate;
     }
     if (set_shp) eni_vcc->tx = tx;
-    DPRINTK("rsv %d shp %d\n",tx->reserved,tx->shaping);
+    pr_debug("rsv %d shp %d\n",tx->reserved,tx->shaping);
     return 0;
 }
 
@@ -1397,7 +1389,7 @@ static void close_tx(struct atm_vcc *vcc)
     if (!eni_vcc->tx) return;
     eni_dev = ENI_DEV(vcc->dev);
     /* wait for TX queue to drain */
-    DPRINTK("eni_close: waiting for TX ...\n");
+    pr_debug("eni_close: waiting for TX ...\n");
     add_wait_queue(&eni_dev->tx_wait,&wait);
     set_current_state(TASK_UNINTERRUPTIBLE);
     for (;;) {
@@ -1407,7 +1399,7 @@ static void close_tx(struct atm_vcc *vcc)
         txing = skb_peek(&eni_vcc->tx->backlog) || eni_vcc->txing;
         tasklet_enable(&eni_dev->task);
         if (!txing) break;
-        DPRINTK("%d TX left\n",eni_vcc->txing);
+        pr_debug("%d TX left\n",eni_vcc->txing);
         schedule();
         set_current_state(TASK_UNINTERRUPTIBLE);
     }
@@ -1471,7 +1463,7 @@ if (eni_boards) printk(KERN_INFO "loss: %ld\n",ENI_DEV(eni_boards)->lost);
 
 static void bug_int(struct atm_dev *dev,unsigned long reason)
 {
-    DPRINTK(">bug_int\n");
+    pr_debug(">bug_int\n");
     if (reason & MID_DMA_ERR_ACK)
         printk(KERN_CRIT DEV_LABEL "(itf %d): driver error - DMA "
             "error\n",dev->number);
@@ -1493,11 +1485,11 @@ static irqreturn_t eni_int(int irq,void *dev_id)
     struct eni_dev *eni_dev;
     u32 reason;
 
-    DPRINTK(">eni_int\n");
+    pr_debug(">eni_int\n");
     dev = dev_id;
     eni_dev = ENI_DEV(dev);
     reason = eni_in(MID_ISA);
-    DPRINTK(DEV_LABEL ": int 0x%lx\n",(unsigned long) reason);
+    pr_debug(DEV_LABEL ": int 0x%lx\n",(unsigned long) reason);
     /*
      * Must handle these two right now, because reading ISA doesn't clear
      * them, so they re-occur and we never make it to the tasklet. Since
@@ -1530,7 +1522,7 @@ static void eni_tasklet(unsigned long data)
     unsigned long flags;
     u32 events;
 
-    DPRINTK("eni_tasklet (dev %p)\n",dev);
+    pr_debug("eni_tasklet (dev %p)\n",dev);
     spin_lock_irqsave(&eni_dev->lock,flags);
     events = xchg(&eni_dev->events,0);
     spin_unlock_irqrestore(&eni_dev->lock,flags);
@@ -1706,7 +1698,7 @@ static int eni_do_init(struct atm_dev *dev)
     void __iomem *base;
     int error,i,last;
 
-    DPRINTK(">eni_init\n");
+    pr_debug(">eni_init\n");
     dev->ci_range.vpi_bits = 0;
     dev->ci_range.vci_bits = NR_VCI_LD;
     dev->link_rate = ATM_OC3_PCR;
@@ -1808,7 +1800,7 @@ static int eni_start(struct atm_dev *dev)
     unsigned long buffer_mem;
     int error;
 
-    DPRINTK(">eni_start\n");
+    pr_debug(">eni_start\n");
     eni_dev = ENI_DEV(dev);
     if (request_irq(eni_dev->irq,&eni_int,IRQF_SHARED,DEV_LABEL,dev)) {
         printk(KERN_ERR DEV_LABEL "(itf %d): IRQ%d is already in use\n",
@@ -1836,7 +1828,7 @@ static int eni_start(struct atm_dev *dev)
     eni_dev->tx_dma = eni_dev->rx_dma+NR_DMA_RX*8;
     eni_dev->service = eni_dev->tx_dma+NR_DMA_TX*8;
     buf = eni_dev->service+NR_SERVICE*4;
-    DPRINTK("vci 0x%lx,rx 0x%lx, tx 0x%lx,srv 0x%lx,buf 0x%lx\n",
+    pr_debug("vci 0x%lx,rx 0x%lx, tx 0x%lx,srv 0x%lx,buf 0x%lx\n",
          eni_dev->vci,eni_dev->rx_dma,eni_dev->tx_dma,
          eni_dev->service,buf);
     spin_lock_init(&eni_dev->lock);
@@ -1893,12 +1885,12 @@ static int eni_start(struct atm_dev *dev)
 
 static void eni_close(struct atm_vcc *vcc)
 {
-    DPRINTK(">eni_close\n");
+    pr_debug(">eni_close\n");
     if (!ENI_VCC(vcc)) return;
     clear_bit(ATM_VF_READY,&vcc->flags);
     close_rx(vcc);
     close_tx(vcc);
-    DPRINTK("eni_close: done waiting\n");
+    pr_debug("eni_close: done waiting\n");
     /* deallocate memory */
     kfree(ENI_VCC(vcc));
     vcc->dev_data = NULL;
@@ -1914,7 +1906,7 @@ static int eni_open(struct atm_vcc *vcc)
     short vpi = vcc->vpi;
     int vci = vcc->vci;
 
-    DPRINTK(">eni_open\n");
+    pr_debug(">eni_open\n");
     EVENT("eni_open\n",0,0);
     if (!test_bit(ATM_VF_PARTIAL,&vcc->flags))
         vcc->dev_data = NULL;
@@ -1922,7 +1914,7 @@ static int eni_open(struct atm_vcc *vcc)
         set_bit(ATM_VF_ADDR,&vcc->flags);
     if (vcc->qos.aal != ATM_AAL0 && vcc->qos.aal != ATM_AAL5)
         return -EINVAL;
-    DPRINTK(DEV_LABEL "(itf %d): open %d.%d\n",vcc->dev->number,vcc->vpi,
+    pr_debug(DEV_LABEL "(itf %d): open %d.%d\n",vcc->dev->number,vcc->vpi,
         vcc->vci);
     if (!test_bit(ATM_VF_PARTIAL,&vcc->flags)) {
         eni_vcc = kmalloc(sizeof(struct eni_vcc),GFP_KERNEL);
@@ -2035,7 +2027,7 @@ static int eni_send(struct atm_vcc *vcc,struct sk_buff *skb)
 {
     enum enq_res res;
 
-    DPRINTK(">eni_send\n");
+    pr_debug(">eni_send\n");
     if (!ENI_VCC(vcc)->tx) {
         if (vcc->pop) vcc->pop(vcc,skb);
         else dev_kfree_skb(skb);
-- 2.39.1

