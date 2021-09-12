Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7BE407FD7
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhILUCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:02:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:51013 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236017AbhILUB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 16:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631476796;
        bh=xizzdkWfxeZMBB0KGWNfW468IvZnVnkVemTYskKzzhE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=jNGlzi/Mm+0zWpm2bzbgCBV+Cdv6eMHMoR5YzBrqqsFAE7PlhTCxkunqtBTOZWbtJ
         He7IMeiY4msAOL29YVp2NISu+bCvYfYYwsz7eo4L4glMgZU9Fa1MRnGPAGywlh12o5
         i41/D+bVR4kqhvqaePMTbzPkIM7OiBCKl/whRQ+c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([92.116.163.18]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N49lJ-1n7t183XIP-0102iO; Sun, 12
 Sep 2021 21:59:55 +0200
Date:   Sun, 12 Sep 2021 21:58:16 +0200
From:   Helge Deller <deller@gmx.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Subject: Re: [PATCH 3/4] parisc: Use absolute_pointer for memcmp on fixed
 memory location
Message-ID: <YT5b2HgrvL12Nrhx@ls3530>
References: <20210912160149.2227137-1-linux@roeck-us.net>
 <20210912160149.2227137-4-linux@roeck-us.net>
 <CAHk-=wi1TBvyk7SWX+5LLYN8ZnTJMut1keQbOrKCG=nb08hdiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1TBvyk7SWX+5LLYN8ZnTJMut1keQbOrKCG=nb08hdiQ@mail.gmail.com>
X-Provags-ID: V03:K1:2VqccK54tmLD+8KuLJZPTw4oAxcDhyy51ck37qk85ZYNmY138c2
 jBP0Q3aPB0Xtn92gFJOFD4jvO5TE1u40FZJasM1hO+bVV2GSPkcIMzA4c7OBcMrJlcjfkui
 DBCHYrmiabot0HDmxtGuwswAVTumOrlRog71FWQoZdJ8Xg1IGPnhIvdZcFEUfwSKsDftZJC
 +ogZUQEE1496xMw4tq5EA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:L6nbEV6rAvY=:iEIhCch8+Uu7QJOcrP3pgj
 FAb8XJ+HCQBnNaIdlfr0dgpGOVTdfSmw45iKoD50UHJ7KhPj/PiFefUXllLeDAM882CdNfRdp
 39YzXeaT3OZKpOid1iFiqwXktjpKGzZpNSNSQI7vOVvAiU94AawBxpY2PquG0Scxu7uSNTg+/
 2TYb4fKNFYcEUTHQ43n7+nBn4MngW/4cUmyiw8avFACbPcssmDddNoPuINYjUPPmgNjbevWWh
 eTXO4YwuTcrT2oKWC8ezMFIxUenQ5VDA1qzIvE4luT7GSI/XRxUYagUHUJtUvLDfdM0yljcIv
 mgxDdAeINkSw2KuKxWWW9lydNVQRva0FhARL0+LuyEVPo0wwoLa+yoOdOUq8ssvInVDPn4MkD
 vaNDEHmZxla3cA3sh/h4k3Z+yjoWiK3lhFLBmw9XSgHhoN3zC99tMco0/kQhHSe8T4+KhUMKI
 vog7x9OVhQa2K2PbFl9X9uWdZkrTYFQ1JK5JYkGROU6/jIjRo2wg5XrWZmkRrTy6rxtQl36yt
 FUvapGVH31o/g1P/97LJ5T6ZPZF8Q2oge+p7jYrwZGwVNHZyQN/dE3bMgh7g8AsCYa6O1tkoY
 urr+ciDWDvyYSmljHT10NGqmhOCE7foTtGi7uajFgc3DdCiIjYnIy/55ZlEQB/wxiwE5dAxtI
 EN+vI6+KdtUBaezumbLGvCxevZszipF6oTyj5PKzXvJV/ipQWapEw86BueAXFJBC/QRCaeZaa
 MylEW5XJauRPFCONTas9PyOiTLmllNcixcdbwC/W21pjjQP/Kjad2ZQC/zQjq2OK/87cPoudQ
 vZmvzA+gsM31+K/bHW1VfoFOvHVKmJBo+d/G1YmhSJbE3s7J4NIAxEJVR5rFGlDj0NxBJUqDk
 MB4fW7/8xTjWsK4uNZVRxcJJhsyaE4UfqFtpMnAGtxx6c0i1km2tU1oDYUsBsOw9ci/a/4VKY
 194PDDugVblUxSp51yk0PnQotVk/DRqddisQ/fUpiBiOdSXxkby6zZwpRTc4wmWklUvqH7XcK
 MTruOQtGX0DT1bT1ZrQ0sMs2kvSwWlLVWUSAZTT3RLX6cYaVBgkQt9ziPZ3R6F7Em8T6K7PHJ
 1A1GnkXyABD2w8=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, Sep 12, 2021 at 9:02 AM Guenter Roeck <linux@roeck-us.net> wrote=
:
> >
> > -       running_on_qemu =3D (memcmp(&PAGE0->pad0, "SeaBIOS", 8) =3D=3D=
 0);
> > +       running_on_qemu =3D (memcmp(absolute_pointer(&PAGE0->pad0), "S=
eaBIOS", 8) =3D=3D 0);
>
> This seems entirely the wrong thing to do, and makes no sense. That
> "&PAGE0->pad0" is a perfectly valid pointer, and that's not where the
> problem is.
>
> The problem is "PAGE0" itself:
>
>     #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
>
> which takes that absolute offset and creates a pointer out of it.
>
> IOW, _that_ is what should have the "absolute_pointer()" thing, and in
> that context the name of that macro and its use actually makes sense.
>
> No?
>
> An alternative - and possibly cleaner - approach that doesn't need
> absolute_pointer() at all might be to just do
>
>         extern struct zeropage PAGE0;
>
> and then make that PAGE0 be defined to __PAGE_OFFSET in the parisc
> vmlinux.lds.S file.
>
> Then doing things like
>
>         running_on_qemu =3D !memcmp(&PAGE0.pad0, "SeaBIOS", 8);
>
> would JustWork(tm).

Yes, this second approach seems to work nicely, although the patch
then gets slightly bigger.
Below is a tested patch.
I'll check it some further and apply it to the parisc tree then.

Thanks!
Helge

=2D-------

[PATCH] Define and export PAGE0 in vmlinux.lds.S linker script

Signed-off-by: Helge Deller <deller@gmx.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>

=2D--

diff --git a/arch/parisc/boot/compressed/misc.c b/arch/parisc/boot/compres=
sed/misc.c
index 7ee49f5881d1..1b957c6bbe5c 100644
=2D-- a/arch/parisc/boot/compressed/misc.c
+++ b/arch/parisc/boot/compressed/misc.c
@@ -319,7 +319,7 @@ unsigned long decompress_kernel(unsigned int started_w=
ide,

 	/* Limit memory for bootoader to 1GB */
 	#define ARTIFICIAL_LIMIT (1*1024*1024*1024)
-	free_mem_end_ptr =3D PAGE0->imm_max_mem;
+	free_mem_end_ptr =3D PAGE0.imm_max_mem;
 	if (free_mem_end_ptr > ARTIFICIAL_LIMIT)
 		free_mem_end_ptr =3D ARTIFICIAL_LIMIT;

diff --git a/arch/parisc/boot/compressed/vmlinux.lds.S b/arch/parisc/boot/=
compressed/vmlinux.lds.S
index ab7b43990857..83a1f8f67aba 100644
=2D-- a/arch/parisc/boot/compressed/vmlinux.lds.S
+++ b/arch/parisc/boot/compressed/vmlinux.lds.S
@@ -14,6 +14,9 @@ ENTRY(startup)

 SECTIONS
 {
+        . =3D __PAGE_OFFSET;
+        PAGE0 =3D .;
+
 	/* palo loads at 0x60000 */
 	/* loaded kernel will move to 0x10000 */
 	. =3D 0xe0000;    /* should not overwrite palo code */
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page=
.h
index d00313d1274e..7b64c05abd0c 100644
=2D-- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -100,6 +100,9 @@ typedef struct __physmem_range {
 extern physmem_range_t pmem_ranges[];
 extern int npmem_ranges;

+/* Address of PAGE0 is defined in vmlinux.lds.S */
+extern struct zeropage PAGE0;
+
 #endif /* !__ASSEMBLY__ */

 /* WARNING: The definitions below must match exactly to sizeof(pte_t)
@@ -184,8 +187,6 @@ extern int npmem_ranges;
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>

-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
-
 /* DEFINITION OF THE ZERO-PAGE (PAG0) */
 /* based on work by Jason Eckhardt (jason@equator.com) */

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 776d624a7207..2e8b6e530c09 100644
=2D-- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -944,9 +944,9 @@ static __init void qemu_header(void)

 	pr_info("#define PARISC_PDC_ENTRY_ORG 0x%04lx\n\n",
 #ifdef CONFIG_64BIT
-		(unsigned long)(PAGE0->mem_pdc_hi) << 32 |
+		(unsigned long)(PAGE0.mem_pdc_hi) << 32 |
 #endif
-		(unsigned long)PAGE0->mem_pdc);
+		(unsigned long)PAGE0.mem_pdc);

 	pr_info("#define PARISC_PDC_CACHE_INFO");
 	p =3D (unsigned long *) &cache_info;
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 7034227dbdf3..17516de2f191 100644
=2D-- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -103,10 +103,10 @@ long real64_call(unsigned long function, ...);
 long real32_call(unsigned long function, ...);

 #ifdef CONFIG_64BIT
-#   define MEM_PDC (unsigned long)(PAGE0->mem_pdc_hi) << 32 | PAGE0->mem_=
pdc
+#   define MEM_PDC (unsigned long)(PAGE0.mem_pdc_hi) << 32 | PAGE0.mem_pd=
c
 #   define mem_pdc_call(args...) unlikely(parisc_narrow_firmware) ? real3=
2_call(MEM_PDC, args) : real64_call(MEM_PDC, args)
 #else
-#   define MEM_PDC (unsigned long)PAGE0->mem_pdc
+#   define MEM_PDC (unsigned long)PAGE0.mem_pdc
 #   define mem_pdc_call(args...) real32_call(MEM_PDC, args)
 #endif

@@ -1249,9 +1249,9 @@ int pdc_iodc_print(const unsigned char *str, unsigne=
d count)

 print:
         spin_lock_irqsave(&pdc_lock, flags);
-        real32_call(PAGE0->mem_cons.iodc_io,
-                    (unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
-                    PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
+        real32_call(PAGE0.mem_cons.iodc_io,
+                    (unsigned long)PAGE0.mem_cons.hpa, ENTRY_IO_COUT,
+                    PAGE0.mem_cons.spa, __pa(PAGE0.mem_cons.dp.layers),
                     __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
         spin_unlock_irqrestore(&pdc_lock, flags);

@@ -1272,14 +1272,14 @@ int pdc_iodc_getc(void)
 	unsigned long flags;

 	/* Bail if no console input device. */
-	if (!PAGE0->mem_kbd.iodc_io)
+	if (!PAGE0.mem_kbd.iodc_io)
 		return 0;

 	/* wait for a keyboard (rs232)-input */
 	spin_lock_irqsave(&pdc_lock, flags);
-	real32_call(PAGE0->mem_kbd.iodc_io,
-		    (unsigned long)PAGE0->mem_kbd.hpa, ENTRY_IO_CIN,
-		    PAGE0->mem_kbd.spa, __pa(PAGE0->mem_kbd.dp.layers),
+	real32_call(PAGE0.mem_kbd.iodc_io,
+		    (unsigned long)PAGE0.mem_kbd.hpa, ENTRY_IO_CIN,
+		    PAGE0.mem_kbd.spa, __pa(PAGE0.mem_kbd.dp.layers),
 		    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), 1, 0);

 	ch =3D *iodc_dbuf;
diff --git a/arch/parisc/kernel/inventory.c b/arch/parisc/kernel/inventory=
.c
index 7ab2f2a54400..13234c663e4b 100644
=2D-- a/arch/parisc/kernel/inventory.c
+++ b/arch/parisc/kernel/inventory.c
@@ -164,7 +164,7 @@ static void __init pagezero_memconfig(void)
 	 * should be done.
 	 */

-	npages =3D (PAGE_ALIGN(PAGE0->imm_max_mem) >> PAGE_SHIFT);
+	npages =3D (PAGE_ALIGN(PAGE0.imm_max_mem) >> PAGE_SHIFT);
 	set_pmem_entry(pmem_ranges,0UL,npages);
 	npmem_ranges =3D 1;
 }
@@ -648,8 +648,8 @@ void __init do_device_inventory(void)
 		struct resource res[3] =3D {0,};
 		unsigned int base;

-		base =3D ((unsigned long long) PAGE0->pad0[2] << 32)
-			| PAGE0->pad0[3]; /* SeaBIOS stored it here */
+		base =3D ((unsigned long long) PAGE0.pad0[2] << 32)
+			| PAGE0.pad0[3]; /* SeaBIOS stored it here */

 		res[0].name =3D "fw_cfg";
 		res[0].start =3D base;
diff --git a/arch/parisc/kernel/kexec.c b/arch/parisc/kernel/kexec.c
index 5eb7f30edc1f..6b39b81a96da 100644
=2D-- a/arch/parisc/kernel/kexec.c
+++ b/arch/parisc/kernel/kexec.c
@@ -96,7 +96,7 @@ void machine_kexec(struct kimage *image)
 	*(unsigned long *)(virt + kexec_cmdline_offset) =3D arch->cmdline;
 	*(unsigned long *)(virt + kexec_initrd_start_offset) =3D arch->initrd_st=
art;
 	*(unsigned long *)(virt + kexec_initrd_end_offset) =3D arch->initrd_end;
-	*(unsigned long *)(virt + kexec_free_mem_offset) =3D PAGE0->mem_free;
+	*(unsigned long *)(virt + kexec_free_mem_offset) =3D PAGE0.mem_free;

 	flush_cache_all();
 	flush_tlb_all();
diff --git a/arch/parisc/kernel/kexec_file.c b/arch/parisc/kernel/kexec_fi=
le.c
index 8c534204f0fd..619aeebc5800 100644
=2D-- a/arch/parisc/kernel/kexec_file.c
+++ b/arch/parisc/kernel/kexec_file.c
@@ -61,7 +61,7 @@ static void *elf_load(struct kimage *image, char *kernel=
_buf,
 		kbuf.bufsz =3D kbuf.memsz =3D ALIGN(cmdline_len, 8);
 		kbuf.buf_align =3D PAGE_SIZE;
 		kbuf.top_down =3D false;
-		kbuf.buf_min =3D PAGE0->mem_free + PAGE_SIZE;
+		kbuf.buf_min =3D PAGE0.mem_free + PAGE_SIZE;
 		kbuf.buf_max =3D kernel_load_addr;
 		kbuf.mem =3D KEXEC_BUF_MEM_UNKNOWN;
 		ret =3D kexec_add_buffer(&kbuf);
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 2661cdd256ae..b635294184b9 100644
=2D-- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -218,8 +218,8 @@ static void pdc_console_init_force(void)
 	++pdc_console_initialized;

 	/* If the console is duplex then copy the COUT parameters to CIN. */
-	if (PAGE0->mem_cons.cl_class =3D=3D CL_DUPLEX)
-		memcpy(&PAGE0->mem_kbd, &PAGE0->mem_cons, sizeof(PAGE0->mem_cons));
+	if (PAGE0.mem_cons.cl_class =3D=3D CL_DUPLEX)
+		memcpy(&PAGE0.mem_kbd, &PAGE0.mem_cons, sizeof(PAGE0.mem_cons));

 	/* register the pdc console */
 	register_console(&pdc_cons);
diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor=
.c
index 1b6129e7d776..7872322336a5 100644
=2D-- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -234,7 +234,7 @@ void __init collect_boot_cpu_data(void)
 	cr16_seed =3D get_cycles();
 	add_device_randomness(&cr16_seed, sizeof(cr16_seed));

-	boot_cpu_data.cpu_hz =3D 100 * PAGE0->mem_10msec; /* Hz of this PARISC *=
/
+	boot_cpu_data.cpu_hz =3D 100 * PAGE0.mem_10msec; /* Hz of this PARISC */

 	/* get CPU-Model Information... */
 #define p ((unsigned long *)&boot_cpu_data.pdc.model)
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index cceb09855e03..0168f7f83fdb 100644
=2D-- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -384,7 +384,7 @@ void __init start_parisc(void)
 	struct pdc_coproc_cfg coproc_cfg;

 	/* check QEMU/SeaBIOS marker in PAGE0 */
-	running_on_qemu =3D (memcmp(&PAGE0->pad0, "SeaBIOS", 8) =3D=3D 0);
+	running_on_qemu =3D (memcmp(&PAGE0.pad0, "SeaBIOS", 8) =3D=3D 0);

 	cpunum =3D smp_processor_id();

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 9fb1e794831b..00283e41fc7f 100644
=2D-- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -237,10 +237,10 @@ void __init time_init(void)
 {
 	unsigned long cr16_hz;

-	clocktick =3D (100 * PAGE0->mem_10msec) / HZ;
+	clocktick =3D (100 * PAGE0.mem_10msec) / HZ;
 	start_cpu_itimer();	/* get CPU 0 started */

-	cr16_hz =3D 100 * PAGE0->mem_10msec;  /* Hz */
+	cr16_hz =3D 100 * PAGE0.mem_10msec;  /* Hz */

 	/* register as sched_clock source */
 	sched_clock_register(read_cr16_sched_clock, BITS_PER_LONG, cr16_hz);
@@ -277,7 +277,7 @@ static int __init init_cr16_clocksource(void)

 	/* register at clocksource framework */
 	clocksource_register_hz(&clocksource_cr16,
-		100 * PAGE0->mem_10msec);
+		100 * PAGE0.mem_10msec);

 	return 0;
 }
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux=
.lds.S
index 2769eb991f58..87abee841182 100644
=2D-- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -55,6 +55,9 @@ jiffies =3D jiffies_64;
 #endif
 SECTIONS
 {
+        . =3D __PAGE_OFFSET;
+        PAGE0 =3D .;
+
 	. =3D KERNEL_BINARY_TEXT_START;

 	__init_begin =3D .;
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 3f7d6d5b56ac..733961eb25a1 100644
=2D-- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -283,7 +283,7 @@ static void __init setup_bootmem(void)

 #define PDC_CONSOLE_IO_IODC_SIZE 32768

-	memblock_reserve(0UL, (unsigned long)(PAGE0->mem_free +
+	memblock_reserve(0UL, (unsigned long)(PAGE0.mem_free +
 				PDC_CONSOLE_IO_IODC_SIZE));
 	memblock_reserve(__pa(KERNEL_BINARY_TEXT_START),
 			(unsigned long)(_end - KERNEL_BINARY_TEXT_START));
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e60690d38d67..9d4ccb8c75bd 100644
=2D-- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1542,7 +1542,7 @@ static void sba_hw_init(struct sba_device *sba_dev)
 		**	o reprogram serial port
 		**	o unblock console output
 		*/
-		if (PAGE0->mem_kbd.cl_class =3D=3D CL_KEYBD) {
+		if (PAGE0.mem_kbd.cl_class =3D=3D CL_KEYBD) {
 			pdc_io_reset_devices();
 		}

@@ -1550,8 +1550,8 @@ static void sba_hw_init(struct sba_device *sba_dev)


 #if 0
-printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.h=
pa,
-	PAGE0->mem_boot.spa, PAGE0->mem_boot.pad, PAGE0->mem_boot.cl_class);
+printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0.mem_boot.hp=
a,
+	PAGE0.mem_boot.spa, PAGE0.mem_boot.pad, PAGE0.mem_boot.cl_class);

 	/*
 	** Need to deal with DMA from LAN.
@@ -1562,8 +1562,8 @@ printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\=
n", PAGE0->mem_boot.hpa,
 	** 	mem_boot hpa 0xf4008000 sba 0x0 pad 0x0 cl_class 0x1002
 	** ARGH! invalid class.
 	*/
-	if ((PAGE0->mem_boot.cl_class !=3D CL_RANDOM)
-		&& (PAGE0->mem_boot.cl_class !=3D CL_SEQU)) {
+	if ((PAGE0.mem_boot.cl_class !=3D CL_RANDOM)
+		&& (PAGE0.mem_boot.cl_class !=3D CL_SEQU)) {
 			pdc_io_reset();
 	}
 #endif
diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon=
.c
index 1b451165311c..d5737d9fa8cf 100644
=2D-- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -395,7 +395,7 @@ static int __init sticonsole_init(void)
     pr_info("sticon: Initializing STI text console.\n");
     console_lock();
     err =3D do_take_over_console(&sti_con, 0, MAX_NR_CONSOLES - 1,
-		PAGE0->mem_cons.cl_class !=3D CL_DUPLEX);
+		PAGE0.mem_cons.cl_class !=3D CL_DUPLEX);
     console_unlock();

     return err;
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/stico=
re.c
index f869b723494f..a6a6b5503ca1 100644
=2D-- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -966,7 +966,7 @@ static int __init sticore_pa_init(struct parisc_device=
 *dev)
 	if (!sti)
 		sti =3D sti_try_rom_generic(hpa, hpa, NULL);
 	if (!sti)
-		sti =3D sti_try_rom_generic(PAGE0->proc_sti, hpa, NULL);
+		sti =3D sti_try_rom_generic(PAGE0.proc_sti, hpa, NULL);
 	if (!sti)
 		return 1;

