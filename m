Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6686D5F1648
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiI3Wph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiI3Wpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:45:35 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CF9E1735
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:45:32 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d2so3944ilr.12
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lXL4sw4Oo+XJi+3UMhVbwX6/UJwLPf7JSZyg6DJznWw=;
        b=swyupZEqtSPyGc+iWOTYJLTpNPwFHrVUQZGWkSLs0/LrBbwl9jhMmNjop95Y9dAOVG
         TT1XD9sscj03GQDw1Mnv2MiuLvPKT/Ld53eh93W2Qe62MVvyPnrim1wvDEmWWQdwacll
         j29wIaai40Dkh3DSpDQd/zK81jdfXimIaeTdYlOUw8XQQc8CgZ7uyJWR4pn8Uw+oYutq
         St7kh1d+s/oGRnfJ8m7Y33j6U33YsjTVNS9CWdKZnKedT2VinURhyIQJCWs2RzuwfGiL
         xGot5AtarVZu15tP0AMfa/tQq+te8ADomvBvkFcBHIPKlt7Wp9F5xsJhQX4nJOf7MqUO
         AzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lXL4sw4Oo+XJi+3UMhVbwX6/UJwLPf7JSZyg6DJznWw=;
        b=E/dqk5nobq8usveD0rowtfZt88h1tcxpox5y7Yj3TndMcEyugLN1+zyCPo+ucwbgml
         6mgl6iaD4BjJDFpHt4p4iIRnf/8cptDa+DLrPfqG9hlDRhjQQI0h1u/u/xzNJsJY8Qk7
         hx/NVWMlDZFrlfZy8EePU1BOy8/vMdwKeJXc5/oqJAZXxQ42OdAw6jXMUrR2Zj+2Jqzk
         nJ575cH5nJmpqo7wTgFwvrbmkH9fNraxlCq7WM7pcSCVNUFx/nCWCse+NaftkQs+C7in
         KjgLxRQIDsZrXRCElWjITosafcFNqh7vQZjHJFaruH4PJ3dPW76rGfFXuSYMv85pXnNb
         XZYA==
X-Gm-Message-State: ACrzQf1Xg9hQKXOi89dVNP6k2rhJUXHqOcwSYCrHxnsAvZFt1BTCB1I6
        iLI1C+SWD4nLr8za29AahmFj9Q==
X-Google-Smtp-Source: AMsMyM7MmFyH/3yOOeVEjUiT12w5WaTPvIV/WAXWyKjuWd+uPhCJZg94/yti9eYWRyVQpEUZaXmDHQ==
X-Received: by 2002:a92:ca46:0:b0:2f9:4272:b4ed with SMTP id q6-20020a92ca46000000b002f94272b4edmr3867204ilo.43.1664577932018;
        Fri, 30 Sep 2022 15:45:32 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g96-20020a028569000000b0035675cdb75esm1364374jai.31.2022.09.30.15.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 15:45:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: update comments
Date:   Fri, 30 Sep 2022 17:45:27 -0500
Message-Id: <20220930224527.3503404-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch just updates comments throughout the IPA code.

Transaction state is now tracked using indexes into an array rather
than linked lists, and a few comments refer to the "old way" of
doing things.  The description of how transactions are used was
changed to refer to "operations" rather than "commands", to
(hopefully) remove a possible ambiguity.

IPA register offsets and fields are now handled differently as well,
and the register documentation is updated to better describe the
code.

A few minor updates to comments were made (e.g., adding a missing
word, fixing a typo or punctuation, etc.).

Finally, the local macro atomic_dec_not_zero() is no longer used, so
it is deleted.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 24 +++++------
 drivers/net/ipa/gsi_private.h  |  8 ++--
 drivers/net/ipa/gsi_trans.c    | 56 ++++++++++++------------
 drivers/net/ipa/gsi_trans.h    |  2 +-
 drivers/net/ipa/ipa_cmd.c      |  2 +-
 drivers/net/ipa/ipa_data.h     |  2 +-
 drivers/net/ipa/ipa_endpoint.c |  2 -
 drivers/net/ipa/ipa_reg.h      | 79 ++++++++++++++--------------------
 8 files changed, 78 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f8036ee78647f..6faa358c53fed 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -56,9 +56,9 @@
  * element can also contain an immediate command, requesting the IPA perform
  * actions other than data transfer.
  *
- * Each TRE refers to a block of data--also located DRAM.  After writing one
- * or more TREs to a channel, the writer (either the IPA or an EE) writes a
- * doorbell register to inform the receiving side how many elements have
+ * Each TRE refers to a block of data--also located in DRAM.  After writing
+ * one or more TREs to a channel, the writer (either the IPA or an EE) writes
+ * a doorbell register to inform the receiving side how many elements have
  * been written.
  *
  * Each channel has a GSI "event ring" associated with it.  An event ring
@@ -1347,8 +1347,8 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
  * we update transactions to record their actual received lengths.
  *
  * When an event for a TX channel arrives we use information in the
- * transaction to report the number of requests and bytes have been
- * transferred.
+ * transaction to report the number of requests and bytes that have
+ * been transferred.
  *
  * This function is called whenever we learn that the GSI hardware has filled
  * new events since the last time we checked.  The ring's index field tells
@@ -1474,7 +1474,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 	iowrite32(val, gsi->virt + GSI_CH_C_DOORBELL_0_OFFSET(channel_id));
 }
 
-/* Consult hardware, move any newly completed transactions to completed list */
+/* Consult hardware, move newly completed transactions to completed state */
 void gsi_channel_update(struct gsi_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
@@ -1515,17 +1515,17 @@ void gsi_channel_update(struct gsi_channel *channel)
  *
  * Return:	Transaction pointer, or null if none are available
  *
- * This function returns the first entry on a channel's completed transaction
- * list.  If that list is empty, the hardware is consulted to determine
- * whether any new transactions have completed.  If so, they're moved to the
- * completed list and the new first entry is returned.  If there are no more
- * completed transactions, a null pointer is returned.
+ * This function returns the first of a channel's completed transactions.
+ * If no transactions are in completed state, the hardware is consulted to
+ * determine whether any new transactions have completed.  If so, they're
+ * moved to completed state and the first such transaction is returned.
+ * If there are no more completed transactions, a null pointer is returned.
  */
 static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
 {
 	struct gsi_trans *trans;
 
-	/* Get the first transaction from the completed list */
+	/* Get the first completed transaction */
 	trans = gsi_channel_trans_complete(channel);
 	if (trans)
 		gsi_trans_move_polled(trans);
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index af4cc13864e21..6a73dae764d49 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -18,13 +18,13 @@ struct gsi_channel;
 
 /**
  * gsi_trans_move_complete() - Mark a GSI transaction completed
- * @trans:	Transaction to commit
+ * @trans:	Transaction whose state is to be updated
  */
 void gsi_trans_move_complete(struct gsi_trans *trans);
 
 /**
  * gsi_trans_move_polled() - Mark a transaction polled
- * @trans:	Transaction to update
+ * @trans:	Transaction whose state is to be updated
  */
 void gsi_trans_move_polled(struct gsi_trans *trans);
 
@@ -97,8 +97,8 @@ void gsi_channel_doorbell(struct gsi_channel *channel);
 /* gsi_channel_update() - Update knowledge of channel hardware state
  * @channel:	Channel to be updated
  *
- * Consult hardware, move any newly completed transactions to a
- * channel's completed list.
+ * Consult hardware, change the state of any newly-completed transactions
+ * on a channel.
  */
 void gsi_channel_update(struct gsi_channel *channel);
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 03e54fc4376a6..c791e32161b93 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -22,37 +22,36 @@
  * DOC: GSI Transactions
  *
  * A GSI transaction abstracts the behavior of a GSI channel by representing
- * everything about a related group of IPA commands in a single structure.
- * (A "command" in this sense is either a data transfer or an IPA immediate
+ * everything about a related group of IPA operations in a single structure.
+ * (A "operation" in this sense is either a data transfer or an IPA immediate
  * command.)  Most details of interaction with the GSI hardware are managed
- * by the GSI transaction core, allowing users to simply describe commands
+ * by the GSI transaction core, allowing users to simply describe operations
  * to be performed.  When a transaction has completed a callback function
  * (dependent on the type of endpoint associated with the channel) allows
  * cleanup of resources associated with the transaction.
  *
- * To perform a command (or set of them), a user of the GSI transaction
+ * To perform an operation (or set of them), a user of the GSI transaction
  * interface allocates a transaction, indicating the number of TREs required
- * (one per command).  If sufficient TREs are available, they are reserved
+ * (one per operation).  If sufficient TREs are available, they are reserved
  * for use in the transaction and the allocation succeeds.  This way
- * exhaustion of the available TREs in a channel ring is detected
- * as early as possible.  All resources required to complete a transaction
- * are allocated at transaction allocation time.
+ * exhaustion of the available TREs in a channel ring is detected as early
+ * as possible.  Any other resources that might be needed to complete a
+ * transaction are also allocated when the transaction is allocated.
  *
- * Commands performed as part of a transaction are represented in an array
- * of Linux scatterlist structures.  This array is allocated with the
- * transaction, and its entries are initialized using standard scatterlist
- * functions (such as sg_set_buf() or skb_to_sgvec()).
+ * Operations performed as part of a transaction are represented in an array
+ * of Linux scatterlist structures, allocated with the transaction.  These
+ * scatterlist structures are initialized by "adding" operations to the
+ * transaction.  If a buffer in an operation must be mapped for DMA, this is
+ * done at the time it is added to the transaction.  It is possible for a
+ * mapping error to occur when an operation is added.  In this case the
+ * transaction should simply be freed; this correctly releases resources
+ * associated with the transaction.
  *
- * Once a transaction's scatterlist structures have been initialized, the
- * transaction is committed.  The caller is responsible for mapping buffers
- * for DMA if necessary, and this should be done *before* allocating
- * the transaction.  Between a successful allocation and commit of a
- * transaction no errors should occur.
- *
- * Committing transfers ownership of the entire transaction to the GSI
- * transaction core.  The GSI transaction code formats the content of
- * the scatterlist array into the channel ring buffer and informs the
- * hardware that new TREs are available to process.
+ * Once all operations have been successfully added to a transaction, the
+ * transaction is committed.  Committing transfers ownership of the entire
+ * transaction to the GSI transaction core.  The GSI transaction code
+ * formats the content of the scatterlist array into the channel ring
+ * buffer and informs the hardware that new TREs are available to process.
  *
  * The last TRE in each transaction is marked to interrupt the AP when the
  * GSI hardware has completed it.  Because transfers described by TREs are
@@ -125,11 +124,10 @@ void gsi_trans_pool_exit(struct gsi_trans_pool *pool)
 	memset(pool, 0, sizeof(*pool));
 }
 
-/* Allocate the requested number of (zeroed) entries from the pool */
-/* Home-grown DMA pool.  This way we can preallocate and use the tre_count
- * to guarantee allocations will succeed.  Even though we specify max_alloc
- * (and it can be more than one), we only allow allocation of a single
- * element from a DMA pool.
+/* Home-grown DMA pool.  This way we can preallocate the pool, and guarantee
+ * allocations will succeed.  The immediate commands in a transaction can
+ * require up to max_alloc elements from the pool.  But we only allow
+ * allocation of a single element from a DMA pool at a time.
  */
 int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 			    size_t size, u32 count, u32 max_alloc)
@@ -537,8 +535,8 @@ static void gsi_trans_tre_fill(struct gsi_tre *dest_tre, dma_addr_t addr,
  *
  * Formats channel ring TRE entries based on the content of the scatterlist.
  * Maps a transaction pointer to the last ring entry used for the transaction,
- * so it can be recovered when it completes.  Moves the transaction to the
- * pending list.  Finally, updates the channel ring pointer and optionally
+ * so it can be recovered when it completes.  Moves the transaction to
+ * pending state.  Finally, updates the channel ring pointer and optionally
  * rings the doorbell.
  */
 static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index af8c4c6719d11..18c4ba2636790 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -74,7 +74,7 @@ struct gsi_trans {
 
 /**
  * gsi_trans_pool_init() - Initialize a pool of structures for transactions
- * @pool:	GSI transaction poll pointer
+ * @pool:	GSI transaction pool pointer
  * @size:	Size of elements in the pool
  * @count:	Minimum number of elements in the pool
  * @max_alloc:	Maximum number of elements allocated at a time from pool
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index f762d7d5f31fa..87014bbcf9714 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -32,7 +32,7 @@
  * immediate command's opcode.  The payload for a command resides in AP
  * memory and is described by a single scatterlist entry in its transaction.
  * Commands do not require a transaction completion callback, and are
- * (currently) always issued using gsi_trans_commit_wait().
+ * always issued using gsi_trans_commit_wait().
  */
 
 /* Some commands can wait until indicated pipeline stages are clear */
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e15eb3cd3e333..e239bcca833da 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -31,7 +31,7 @@
  * communication path between the IPA and a particular execution environment
  * (EE), such as the AP or Modem.  Each EE has a set of channels associated
  * with it, and each channel has an ID unique for that EE.  For the most part
- * the only GSI channels of concern to this driver belong to the AP
+ * the only GSI channels of concern to this driver belong to the AP.
  *
  * An endpoint is an IPA construct representing a single channel anywhere
  * in the system.  An IPA endpoint ID maps directly to an (EE, channel_id)
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 0da02d8d238d1..a09f323a7e9f6 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -23,8 +23,6 @@
 #include "ipa_gsi.h"
 #include "ipa_power.h"
 
-#define atomic_dec_not_zero(v)	atomic_add_unless((v), -1, 0)
-
 /* Hardware is told about receive buffers once a "batch" has been queued */
 #define IPA_REPLENISH_BATCH	16		/* Must be non-zero */
 
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index f81381891a2e4..3c768c9d3d100 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -17,53 +17,38 @@ struct ipa;
  * DOC: IPA Registers
  *
  * IPA registers are located within the "ipa-reg" address space defined by
- * Device Tree.  The offset of each register within that space is specified
- * by symbols defined below.  The address space is mapped to virtual memory
- * space in ipa_mem_init().  All IPA registers are 32 bits wide.
- *
- * Certain register types are duplicated for a number of instances of
- * something.  For example, each IPA endpoint has an set of registers
- * defining its configuration.  The offset to an endpoint's set of registers
- * is computed based on an "base" offset, plus an endpoint's ID multiplied
- * and a "stride" value for the register.  For such registers, the offset is
- * computed by a function-like macro that takes a parameter used in the
- * computation.
- *
- * Some register offsets depend on execution environment.  For these an "ee"
- * parameter is supplied to the offset macro.  The "ee" value is a member of
- * the gsi_ee enumerated type.
- *
- * The offset of a register dependent on endpoint ID is computed by a macro
- * that is supplied a parameter "ep", "txep", or "rxep".  A register with an
- * "ep" parameter is valid for any endpoint; a register with a "txep" or
- * "rxep" parameter is valid only for TX or RX endpoints, respectively.  The
- * "*ep" value is assumed to be less than the maximum valid endpoint ID
- * for the current hardware, and that will not exceed IPA_ENDPOINT_MAX.
- *
- * The offset of registers related to filter and route tables is computed
- * by a macro that is supplied a parameter "er".  The "er" represents an
- * endpoint ID for filters, or a route ID for routes.  For filters, the
- * endpoint ID must be less than IPA_ENDPOINT_MAX, but is further restricted
- * because not all endpoints support filtering.  For routes, the route ID
- * must be less than IPA_ROUTE_MAX.
- *
- * The offset of registers related to resource types is computed by a macro
- * that is supplied a parameter "rt".  The "rt" represents a resource type,
- * which is a member of the ipa_resource_type_src enumerated type for
- * source endpoint resources or the ipa_resource_type_dst enumerated type
- * for destination endpoint resources.
- *
- * Some registers encode multiple fields within them.  For these, each field
- * has a symbol below defining a field mask that encodes both the position
- * and width of the field within its register.
- *
- * In some cases, different versions of IPA hardware use different offset or
- * field mask values.  In such cases an inline_function(ipa) is used rather
- * than a MACRO to define the offset or field mask to use.
- *
- * Finally, some registers hold bitmasks representing endpoints.  In such
- * cases the @available field in the @ipa structure defines the "full" set
- * of valid bits for the register.
+ * Device Tree.  Each register has a specified offset within that space,
+ * which is mapped into virtual memory space in ipa_mem_init().  Each
+ * has a unique identifer, taken from the ipa_reg_id enumerated type.
+ * All IPA registers are 32 bits wide.
+ *
+ * Certain "parameterized" register types are duplicated for a number of
+ * instances of something.  For example, each IPA endpoint has an set of
+ * registers defining its configuration.  The offset to an endpoint's set
+ * of registers is computed based on an "base" offset, plus an endpoint's
+ * ID multiplied and a "stride" value for the register.  Similarly, some
+ * registers have an offset that depends on execution environment.  In
+ * this case, the stride is multiplied by a member of the gsi_ee_id
+ * enumerated type.
+ *
+ * Each version of IPA implements an array of ipa_reg structures indexed
+ * by register ID.  Each entry in the array specifies the base offset and
+ * (for parameterized registers) a non-zero stride value.  Not all versions
+ * of IPA define all registers.  The offset for a register is returned by
+ * ipa_reg_offset() when the register's ipa_reg structure is supplied;
+ * zero is returned for an undefined register (this should never happen).
+ *
+ * Some registers encode multiple fields within them.  Each field in
+ * such a register has a unique identifier (from an enumerated type).
+ * The position and width of the fields in a register are defined by
+ * an array of field masks, indexed by field ID.  Two functions are
+ * used to access register fields; both take an ipa_reg structure as
+ * argument.  To encode a value to be represented in a register field,
+ * the value and field ID are passed to ipa_reg_encode().  To extract
+ * a value encoded in a register field, the field ID is passed to
+ * ipa_reg_decode().  In addition, for single-bit fields, ipa_reg_bit()
+ * can be used to either encode the bit value, or to generate a mask
+ * used to extract the bit value.
  */
 
 /* enum ipa_reg_id - IPA register IDs */
-- 
2.34.1

