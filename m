Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC54C9B89
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiCBCxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiCBCxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:53:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A8DE86;
        Tue,  1 Mar 2022 18:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646189558; x=1677725558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bp46QRO9ZhWM8x67zvEE7CpSORkCePiiXpcbYeeuOo4=;
  b=jPLrrih9moc0ZNy7RAGFOmyx0Jcip3tOaNuC7scRTPBhBamQu5tw20ES
   T2WZVfa7DHSzhbnxih+LAcTibUQUlsRsq8HFe3I6/SzvnL3uc4cqg87jC
   2nUA+X975yUmA7joxGEGy4+bmkECy3qwAg2BOsA7XBzje4NCsYCQeJ0SE
   ODhbFCseLui8ewVCEs64ADQtmybWD4/GWNeDk3hcM+Ej+3RDh+7wZUHzX
   W5svNHczf6FiIcN/3ys+kAfVherAArGgsT4K//d3Y8CZUNPZUsqh6GYUK
   k5T43PCd3hfJ47Pk9n2HTf6UokzNWOmJxGreH3CbKPyv8s2oeDA/Ad4SR
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="277966824"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="277966824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 18:52:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="593859117"
Received: from lkp-server02.sh.intel.com (HELO e9605edfa585) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 01 Mar 2022 18:52:34 -0800
Received: from kbuild by e9605edfa585 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nPF6P-0000xb-Tx; Wed, 02 Mar 2022 02:52:33 +0000
Date:   Wed, 2 Mar 2022 10:52:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        torvalds@linux-foundation.org
Cc:     kbuild-all@lists.01.org, arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
Message-ID: <202203020904.iuHFI2tk-lkp@intel.com>
References: <20220301075839.4156-3-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301075839.4156-3-xiam0nd.tong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaomeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linux/master]
[also build test WARNING on vkoul-dmaengine/next soc/for-next linus/master v5.17-rc6 next-20220301]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Xiaomeng-Tong/list_for_each_entry-make-iterator-invisiable-outside-the-loop/20220301-160113
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2c271fe77d52a0555161926c232cd5bc07178b39
reproduce: make htmldocs

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> include/linux/list.h:931: warning: expecting prototype for list_for_each_entry_safe_reverse_insde(). Prototype was for list_for_each_entry_safe_reverse_inside() instead

vim +931 include/linux/list.h

   557	
   558	/**
   559	 * list_next_entry - get the next element in list
   560	 * @pos:	the type * to cursor
   561	 * @member:	the name of the list_head within the struct.
   562	 */
   563	#define list_next_entry(pos, member) \
   564		list_entry((pos)->member.next, typeof(*(pos)), member)
   565	
   566	/**
   567	 * list_prev_entry - get the prev element in list
   568	 * @pos:	the type * to cursor
   569	 * @member:	the name of the list_head within the struct.
   570	 */
   571	#define list_prev_entry(pos, member) \
   572		list_entry((pos)->member.prev, typeof(*(pos)), member)
   573	
   574	/**
   575	 * list_for_each	-	iterate over a list
   576	 * @pos:	the &struct list_head to use as a loop cursor.
   577	 * @head:	the head for your list.
   578	 */
   579	#define list_for_each(pos, head) \
   580		for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
   581	
   582	/**
   583	 * list_for_each_continue - continue iteration over a list
   584	 * @pos:	the &struct list_head to use as a loop cursor.
   585	 * @head:	the head for your list.
   586	 *
   587	 * Continue to iterate over a list, continuing after the current position.
   588	 */
   589	#define list_for_each_continue(pos, head) \
   590		for (pos = pos->next; !list_is_head(pos, (head)); pos = pos->next)
   591	
   592	/**
   593	 * list_for_each_prev	-	iterate over a list backwards
   594	 * @pos:	the &struct list_head to use as a loop cursor.
   595	 * @head:	the head for your list.
   596	 */
   597	#define list_for_each_prev(pos, head) \
   598		for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
   599	
   600	/**
   601	 * list_for_each_safe - iterate over a list safe against removal of list entry
   602	 * @pos:	the &struct list_head to use as a loop cursor.
   603	 * @n:		another &struct list_head to use as temporary storage
   604	 * @head:	the head for your list.
   605	 */
   606	#define list_for_each_safe(pos, n, head) \
   607		for (pos = (head)->next, n = pos->next; \
   608		     !list_is_head(pos, (head)); \
   609		     pos = n, n = pos->next)
   610	
   611	/**
   612	 * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
   613	 * @pos:	the &struct list_head to use as a loop cursor.
   614	 * @n:		another &struct list_head to use as temporary storage
   615	 * @head:	the head for your list.
   616	 */
   617	#define list_for_each_prev_safe(pos, n, head) \
   618		for (pos = (head)->prev, n = pos->prev; \
   619		     !list_is_head(pos, (head)); \
   620		     pos = n, n = pos->prev)
   621	
   622	/**
   623	 * list_entry_is_head - test if the entry points to the head of the list
   624	 * @pos:	the type * to cursor
   625	 * @head:	the head for your list.
   626	 * @member:	the name of the list_head within the struct.
   627	 */
   628	#define list_entry_is_head(pos, head, member)				\
   629		(&pos->member == (head))
   630	
   631	/**
   632	 * list_for_each_entry	-	iterate over list of given type
   633	 * @pos:	the type * to use as a loop cursor.
   634	 * @head:	the head for your list.
   635	 * @member:	the name of the list_head within the struct.
   636	 */
   637	#define list_for_each_entry(pos, head, member)				\
   638		for (pos = list_first_entry(head, typeof(*pos), member);	\
   639		     !list_entry_is_head(pos, head, member);			\
   640		     pos = list_next_entry(pos, member))
   641	
   642	/**
   643	 * list_for_each_entry_inside
   644	 *  - iterate over list of given type and keep iterator inside the loop
   645	 * @pos:	the type * to use as a loop cursor.
   646	 * @type:	the type of the container struct this is embedded in.
   647	 * @head:	the head for your list.
   648	 * @member:	the name of the list_head within the struct.
   649	 */
   650	#define list_for_each_entry_inside(pos, type, head, member)		\
   651		for (type * pos = list_first_entry(head, type, member);		\
   652		     !list_entry_is_head(pos, head, member);			\
   653		     pos = list_next_entry(pos, member))
   654	
   655	/**
   656	 * list_for_each_entry_reverse - iterate backwards over list of given type.
   657	 * @pos:	the type * to use as a loop cursor.
   658	 * @head:	the head for your list.
   659	 * @member:	the name of the list_head within the struct.
   660	 */
   661	#define list_for_each_entry_reverse(pos, head, member)			\
   662		for (pos = list_last_entry(head, typeof(*pos), member);		\
   663		     !list_entry_is_head(pos, head, member); 			\
   664		     pos = list_prev_entry(pos, member))
   665	
   666	/**
   667	 * list_for_each_entry_reverse_inside
   668	 * - iterate backwards over list of given type and keep iterator inside the loop.
   669	 * @pos:	the type * to use as a loop cursor.
   670	 * @type:	the type of the container struct this is embedded in.
   671	 * @head:	the head for your list.
   672	 * @member:	the name of the list_head within the struct.
   673	 */
   674	#define list_for_each_entry_reverse_inside(pos, type, head, member)	\
   675		for (type * pos = list_last_entry(head, type, member);		\
   676		     !list_entry_is_head(pos, head, member);			\
   677		     pos = list_prev_entry(pos, member))
   678	
   679	/**
   680	 * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
   681	 * @pos:	the type * to use as a start point
   682	 * @head:	the head of the list
   683	 * @member:	the name of the list_head within the struct.
   684	 *
   685	 * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
   686	 */
   687	#define list_prepare_entry(pos, head, member) \
   688		((pos) ? : list_entry(head, typeof(*pos), member))
   689	
   690	/**
   691	 * list_for_each_entry_continue - continue iteration over list of given type
   692	 * @pos:	the type * to use as a loop cursor.
   693	 * @head:	the head for your list.
   694	 * @member:	the name of the list_head within the struct.
   695	 *
   696	 * Continue to iterate over list of given type, continuing after
   697	 * the current position.
   698	 */
   699	#define list_for_each_entry_continue(pos, head, member) 		\
   700		for (pos = list_next_entry(pos, member);			\
   701		     !list_entry_is_head(pos, head, member);			\
   702		     pos = list_next_entry(pos, member))
   703	
   704	/**
   705	 * list_for_each_entry_continue_inside
   706	 *  - continue iteration over list of given type and keep iterator inside the loop
   707	 * @pos:	the type * to use as a loop cursor.
   708	 * @start:	the given iterator to start with.
   709	 * @head:	the head for your list.
   710	 * @member:	the name of the list_head within the struct.
   711	 *
   712	 * Continue to iterate over list of given type, continuing after
   713	 * the current position.
   714	 */
   715	#define list_for_each_entry_continue_inside(pos, start, head, member)	\
   716		for (typeof(*start) *pos = list_next_entry(start, member);	\
   717		     !list_entry_is_head(pos, head, member);			\
   718		     pos = list_next_entry(pos, member))
   719	
   720	/**
   721	 * list_for_each_entry_continue_reverse - iterate backwards from the given point
   722	 * @pos:	the type * to use as a loop cursor.
   723	 * @head:	the head for your list.
   724	 * @member:	the name of the list_head within the struct.
   725	 *
   726	 * Start to iterate over list of given type backwards, continuing after
   727	 * the current position.
   728	 */
   729	#define list_for_each_entry_continue_reverse(pos, head, member)		\
   730		for (pos = list_prev_entry(pos, member);			\
   731		     !list_entry_is_head(pos, head, member);			\
   732		     pos = list_prev_entry(pos, member))
   733	
   734	/**
   735	 * list_for_each_entry_continue_reverse_inside
   736	 *  - iterate backwards from the given point and keep iterator inside the loop
   737	 * @pos:	the type * to use as a loop cursor.
   738	 * @start:	the given iterator to start with.
   739	 * @head:	the head for your list.
   740	 * @member:	the name of the list_head within the struct.
   741	 *
   742	 * Start to iterate over list of given type backwards, continuing after
   743	 * the current position.
   744	 */
   745	#define list_for_each_entry_continue_reverse_inside(pos, start, head, member)	\
   746		for (typeof(*start) *pos = list_prev_entry(start, member);		\
   747		     !list_entry_is_head(pos, head, member);				\
   748		     pos = list_prev_entry(pos, member))
   749	
   750	/**
   751	 * list_for_each_entry_from - iterate over list of given type from the current point
   752	 * @pos:	the type * to use as a loop cursor.
   753	 * @head:	the head for your list.
   754	 * @member:	the name of the list_head within the struct.
   755	 *
   756	 * Iterate over list of given type, continuing from current position.
   757	 */
   758	#define list_for_each_entry_from(pos, head, member) 			\
   759		for (; !list_entry_is_head(pos, head, member);			\
   760		     pos = list_next_entry(pos, member))
   761	
   762	/**
   763	 * list_for_each_entry_from_inside
   764	 *  - iterate over list of given type from the current point and keep iterator inside the loop
   765	 * @pos:	the type * to use as a loop cursor.
   766	 * @start:	the given iterator to start with.
   767	 * @head:	the head for your list.
   768	 * @member:	the name of the list_head within the struct.
   769	 *
   770	 * Iterate over list of given type, continuing from current position.
   771	 */
   772	#define list_for_each_entry_from_inside(pos, start, head, member)			\
   773		for (typeof(*start) *pos = start; !list_entry_is_head(pos, head, member);	\
   774		     pos = list_next_entry(pos, member))
   775	
   776	/**
   777	 * list_for_each_entry_from_reverse - iterate backwards over list of given type
   778	 *                                    from the current point
   779	 * @pos:	the type * to use as a loop cursor.
   780	 * @head:	the head for your list.
   781	 * @member:	the name of the list_head within the struct.
   782	 *
   783	 * Iterate backwards over list of given type, continuing from current position.
   784	 */
   785	#define list_for_each_entry_from_reverse(pos, head, member)		\
   786		for (; !list_entry_is_head(pos, head, member);			\
   787		     pos = list_prev_entry(pos, member))
   788	
   789	/**
   790	 * list_for_each_entry_from_reverse_inside
   791	 *  - iterate backwards over list of given type from the current point
   792	 *    and keep iterator inside the loop
   793	 * @pos:	the type * to use as a loop cursor.
   794	 * @start:	the given iterator to start with.
   795	 * @head:	the head for your list.
   796	 * @member:	the name of the list_head within the struct.
   797	 *
   798	 * Iterate backwards over list of given type, continuing from current position.
   799	 */
   800	#define list_for_each_entry_from_reverse_inside(pos, start, head, member)		\
   801		for (typeof(*start) *pos = start; !list_entry_is_head(pos, head, member);	\
   802		     pos = list_prev_entry(pos, member))
   803	
   804	/**
   805	 * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
   806	 * @pos:	the type * to use as a loop cursor.
   807	 * @n:		another type * to use as temporary storage
   808	 * @head:	the head for your list.
   809	 * @member:	the name of the list_head within the struct.
   810	 */
   811	#define list_for_each_entry_safe(pos, n, head, member)			\
   812		for (pos = list_first_entry(head, typeof(*pos), member),	\
   813			n = list_next_entry(pos, member);			\
   814		     !list_entry_is_head(pos, head, member); 			\
   815		     pos = n, n = list_next_entry(n, member))
   816	
   817	/**
   818	 * list_for_each_entry_safe_inside
   819	 *  - iterate over list of given type safe against removal of list entry
   820	 *    and keep iterator inside the loop
   821	 * @pos:	the type * to use as a loop cursor.
   822	 * @n:		another type * to use as temporary storage
   823	 * @type:	the type of the container struct this is embedded in.
   824	 * @head:	the head for your list.
   825	 * @member:	the name of the list_head within the struct.
   826	 */
   827	#define list_for_each_entry_safe_inside(pos, n, type, head, member)	\
   828		for (type * pos = list_first_entry(head, type, member),		\
   829			*n = list_next_entry(pos, member);			\
   830		     !list_entry_is_head(pos, head, member);			\
   831		     pos = n, n = list_next_entry(n, member))
   832	
   833	/**
   834	 * list_for_each_entry_safe_continue - continue list iteration safe against removal
   835	 * @pos:	the type * to use as a loop cursor.
   836	 * @n:		another type * to use as temporary storage
   837	 * @head:	the head for your list.
   838	 * @member:	the name of the list_head within the struct.
   839	 *
   840	 * Iterate over list of given type, continuing after current point,
   841	 * safe against removal of list entry.
   842	 */
   843	#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
   844		for (pos = list_next_entry(pos, member), 				\
   845			n = list_next_entry(pos, member);				\
   846		     !list_entry_is_head(pos, head, member);				\
   847		     pos = n, n = list_next_entry(n, member))
   848	
   849	/**
   850	 * list_for_each_entry_safe_continue_inside
   851	 *  - continue list iteration safe against removal and keep iterator inside the loop
   852	 * @pos:	the type * to use as a loop cursor.
   853	 * @n:		another type * to use as temporary storage
   854	 * @start:	the given iterator to start with.
   855	 * @head:	the head for your list.
   856	 * @member:	the name of the list_head within the struct.
   857	 *
   858	 * Iterate over list of given type, continuing after current point,
   859	 * safe against removal of list entry.
   860	 */
   861	#define list_for_each_entry_safe_continue_inside(pos, n, start, head, member)	\
   862		for (typeof(*start) *pos = list_next_entry(start, member),		\
   863			*n = list_next_entry(pos, member);				\
   864		     !list_entry_is_head(pos, head, member);				\
   865		     pos = n, n = list_next_entry(n, member))
   866	
   867	/**
   868	 * list_for_each_entry_safe_from - iterate over list from current point safe against removal
   869	 * @pos:	the type * to use as a loop cursor.
   870	 * @n:		another type * to use as temporary storage
   871	 * @head:	the head for your list.
   872	 * @member:	the name of the list_head within the struct.
   873	 *
   874	 * Iterate over list of given type from current point, safe against
   875	 * removal of list entry.
   876	 */
   877	#define list_for_each_entry_safe_from(pos, n, head, member) 			\
   878		for (n = list_next_entry(pos, member);					\
   879		     !list_entry_is_head(pos, head, member);				\
   880		     pos = n, n = list_next_entry(n, member))
   881	
   882	/**
   883	 * list_for_each_entry_safe_from_inside
   884	 *  - iterate over list from current point safe against removal and keep iterator inside the loop
   885	 * @pos:	the type * to use as a loop cursor.
   886	 * @n:		another type * to use as temporary storage
   887	 * @start:	the given iterator to start with.
   888	 * @head:	the head for your list.
   889	 * @member:	the name of the list_head within the struct.
   890	 *
   891	 * Iterate over list of given type from current point, safe against
   892	 * removal of list entry.
   893	 */
   894	#define list_for_each_entry_safe_from_inside(pos, n, start, head, member)	\
   895		for (typeof(*start) *pos = start, *n = list_next_entry(pos, member);	\
   896		     !list_entry_is_head(pos, head, member);				\
   897		     pos = n, n = list_next_entry(n, member))
   898	
   899	/**
   900	 * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
   901	 * @pos:	the type * to use as a loop cursor.
   902	 * @n:		another type * to use as temporary storage
   903	 * @head:	the head for your list.
   904	 * @member:	the name of the list_head within the struct.
   905	 *
   906	 * Iterate backwards over list of given type, safe against removal
   907	 * of list entry.
   908	 */
   909	#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
   910		for (pos = list_last_entry(head, typeof(*pos), member),		\
   911			n = list_prev_entry(pos, member);			\
   912		     !list_entry_is_head(pos, head, member); 			\
   913		     pos = n, n = list_prev_entry(n, member))
   914	
   915	/**
   916	 * list_for_each_entry_safe_reverse_insde
   917	 *  - iterate backwards over list safe against removal and keep iterator inside the loop
   918	 * @pos:	the type * to use as a loop cursor.
   919	 * @n:		another type * to use as temporary storage
   920	 * @type:	the type of the struct this is enmbeded in.
   921	 * @head:	the head for your list.
   922	 * @member:	the name of the list_head within the struct.
   923	 *
   924	 * Iterate backwards over list of given type, safe against removal
   925	 * of list entry.
   926	 */
   927	#define list_for_each_entry_safe_reverse_inside(pos, n, type, head, member)	\
   928		for (type * pos = list_last_entry(head, type, member),			\
   929			*n = list_prev_entry(pos, member);				\
   930		     !list_entry_is_head(pos, head, member);				\
 > 931		     pos = n, n = list_prev_entry(n, member))
   932	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
